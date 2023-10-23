import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../infrastructure/routing/app_router.dart';
import '../../../../../app_constants.dart';
import '../../../../../data/cache/caching_manager.dart';
import '../../../../../data/models/enums/fortunica_user_status.dart';
import '../../../../../data/models/enums/markets_type.dart';
import '../../../../../data/models/user_info/localized_properties/property_by_language.dart';
import '../../../../../data/models/user_info/user_info.dart';
import '../../../../../data/models/user_info/user_profile.dart';
import '../../../../../data/models/user_info/user_status.dart';
import '../../../../../data/network/requests/push_enable_request.dart';
import '../../../../../data/network/requests/set_push_notification_token_request.dart';
import '../../../../../data/network/requests/update_user_status_request.dart';
import '../../../../../domain/repositories/fortunica_user_repository.dart';
import '../../../../../global.dart';
import '../../../../../infrastructure/routing/app_router.gr.dart';
import '../../../../../main_cubit.dart';
import '../../../../../services/connectivity_service.dart';
import '../../../../../services/push_notification/push_notification_manager.dart';
import 'account_state.dart';

class AccountCubit extends Cubit<AccountState> {
  final CachingManager _cacheManager;
  final MainCubit _mainCubit;
  final FortunicaUserRepository _userRepository;
  final ConnectivityService _connectivityService;

  final TextEditingController commentController = TextEditingController();
  final FocusNode commentNode = FocusNode();

  final Future<bool> Function(bool needShowSettingsAlert) _handlePermission;

  final PushNotificationManager _pushNotificationManager;

  final Uri _url = Uri.parse(AppConstants.webToolUrl);

  late final StreamSubscription _userProfileSubscription;
  late final StreamSubscription<bool> _appOnResumeSubscription;
  late final StreamSubscription<bool> _updateAccountSubscription;
  StreamSubscription<bool>? _connectivitySubscription;
  StreamSubscription? _currentBrandSubscription;

  bool? isPushNotificationPermissionGranted;
  Timer? _timer;
  bool _isFirstLoadUserInfo = true;
  bool isTimeout = false;

  AccountCubit(
    this._cacheManager,
    this._mainCubit,
    this._userRepository,
    this._pushNotificationManager,
    this._connectivityService,
    this._handlePermission,
  ) : super(const AccountState()) {
    final UserProfile? userProfile = _cacheManager.getUserProfile();
    emit(state.copyWith(userProfile: userProfile));

    firstGetUserInfo();

    _userProfileSubscription = _cacheManager.listenUserProfileStream((value) {
      emit(state.copyWith(userProfile: value));
    });

    commentNode.addListener(() {
      emit(state.copyWith(commentHasFocus: commentNode.hasFocus));
    });

    commentController.addListener(() {
      emit(
        state.copyWith(
          commentButtonIsActive: commentController.text.isNotEmpty,
        ),
      );
    });

    _appOnResumeSubscription = _mainCubit.changeAppLifecycleStream.listen(
      (value) async {
        if (value) {
          final bool newPushPermissionsValue = await _handlePermission(false);

          if (isPushNotificationPermissionGranted != newPushPermissionsValue) {
            isPushNotificationPermissionGranted = newPushPermissionsValue;
            _cacheManager.pushTokenIsSent = false;
            await refreshUserinfo();
          }
        }
      },
    );

    _updateAccountSubscription = _mainCubit.updateAccountTrigger.listen(
      (value) {
        refreshUserinfo();
      },
    );
  }

  @override
  Future<void> close() async {
    _timer?.cancel();
    _currentBrandSubscription?.cancel();
    _appOnResumeSubscription.cancel();
    _connectivitySubscription?.cancel();
    _updateAccountSubscription.cancel();
    _userProfileSubscription.cancel();
    commentController.dispose();
    commentNode.dispose();
    return super.close();
  }

  Future<void> firstGetUserInfo() async {
    if (_isFirstLoadUserInfo) {
      await refreshUserinfo();
    }
  }

  Future<void> refreshUserinfo() async {
    try {
      if (await _connectivityService.checkConnection()) {
        int milliseconds = 0;

        isPushNotificationPermissionGranted = await _handlePermission(false);
        final UserInfo userInfo = await _userRepository.getUserInfo();

        if (isPushNotificationPermissionGranted == true) {
          _pushNotificationManager.registerForPushNotifications();
          await _sendPushToken();
        }

        await _saveUserInfo(userInfo);

        final DateTime? profileUpdatedAt =
            _cacheManager.getUserStatus()?.profileUpdatedAt;

        if (profileUpdatedAt != null) {
          DateTime currentTime = DateTime.now().toUtc();
          currentTime = currentTime.add(const Duration(seconds: 15));
          milliseconds =
              currentTime.difference(profileUpdatedAt).inMilliseconds;
        }

        final int millisecondsForTimer = milliseconds > 0
            ? AppConstants.millisecondsInHour - milliseconds
            : milliseconds;

        if (millisecondsForTimer > 0) {
          _startTimer(millisecondsForTimer);
        }

        emit(
          state.copyWith(
            userProfile: _cacheManager.getUserProfile(),
            enableNotifications: (userInfo.pushNotificationsEnabled ?? false) &&
                isPushNotificationPermissionGranted == true,
          ),
        );
        _isFirstLoadUserInfo = false;
      }
      emit(state.copyWith(isTimeout: false));
    } catch (e) {
      emit(state.copyWith(isTimeout: true));
    }
  }

  bool checkPropertiesMapIfHasEmpty(UserInfo userInfo) {
    final Map<String, dynamic> propertiesMap =
        userInfo.profile?.localizedProperties?.toJson() ?? {};

    if (propertiesMap.isNotEmpty) {
      for (MarketsType marketsType in userInfo.profile?.activeLanguages ?? []) {
        final PropertyByLanguage property = propertiesMap[marketsType.name];
        if (property.statusMessage?.trim().isEmpty == true ||
            property.description?.trim().isEmpty == true) {
          return true;
        }
      }
    }
    return false;
  }

  Future<void> _saveUserInfo(UserInfo userInfo) async {
    await _cacheManager.saveUserInfo(userInfo);
    await _cacheManager.saveUserProfile(userInfo.profile);
    await _cacheManager.saveUserId(userInfo.id);

    final UserStatus? userStatus = userInfo.status;

    if (userStatus?.status == FortunicaUserStatus.live ||
        userStatus?.status == FortunicaUserStatus.offline) {
      if (userInfo.contracts?.updates?.isNotEmpty == true) {
        await _cacheManager.saveUserStatus(userStatus?.copyWith(
          status: FortunicaUserStatus.legalBlock,
        ));
      } else {
        if (checkPropertiesMapIfHasEmpty(userInfo) ||
            (userInfo.profile?.profileName?.length ?? 0) <
                AppConstants.minNickNameLength ||
            userInfo.profile?.profilePictures?.isNotEmpty != true) {
          await _cacheManager.saveUserStatus(userStatus?.copyWith(
            status: FortunicaUserStatus.incomplete,
          ));
        } else {
          await _cacheManager.saveUserStatus(userStatus);
        }
      }
    } else {
      await _cacheManager.saveUserStatus(userStatus);
    }
  }

  void _startTimer(int millisecondsForTimer) {
    _timer?.cancel();
    int start = millisecondsForTimer ~/ 1000;
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        if (start <= 0) {
          timer.cancel();
        }
        emit(state.copyWith(
          secondsForTimer: start--,
        ));
      },
    );
  }

  Future<UserInfo?> _setPushEnabledForBackend(bool value) async {
    UserInfo? userInfo =
        await _userRepository.setPushEnabled(PushEnableRequest(value: value));

    await _cacheManager.saveUserInfo(userInfo);
    return userInfo;
  }

  Future<void> updateUserStatus({required FortunicaUserStatus status}) async {
    try {
      final UpdateUserStatusRequest request = UpdateUserStatusRequest(
        status: status,
        comment: commentController.text,
      );
      await _userRepository.updateUserStatus(request);
      refreshUserinfo();
    } catch (e) {
      logger.d(e);
    }
  }

  Future<void> updateEnableNotificationsValue(bool newValue) async {
    try {
      if (newValue) {
        if (isPushNotificationPermissionGranted == true) {
          await _sendPushToken();
          await _setPushEnabledForBackend(newValue);
          emit(
            state.copyWith(
              enableNotifications: newValue,
            ),
          );
        } else {
          _handlePermission(true);
        }
      } else {
        await _setPushEnabledForBackend(newValue);
        emit(
          state.copyWith(
            enableNotifications: newValue,
          ),
        );
      }
    } catch (e) {
      logger.d(e);
    }
  }

  Future<void> _sendPushToken() async {
    if (!_cacheManager.pushTokenIsSent) {
      if (await _connectivityService.checkConnection()) {
        String? pushToken = await _pushNotificationManager.getToken();
        if (pushToken != null) {
          final SetPushNotificationTokenRequest request =
              SetPushNotificationTokenRequest(
            pushToken: pushToken,
          );
          final UserInfo userInfo =
              await _userRepository.sendPushToken(request);
          emit(
            state.copyWith(
              enableNotifications: userInfo.pushNotificationsEnabled ?? false,
            ),
          );
          _cacheManager.pushTokenIsSent = true;
        }
        _connectivitySubscription?.cancel();
      } else {
        _connectivitySubscription =
            _connectivityService.connectivityStream.listen((event) {
          if (event) {
            _sendPushToken();
          }
        });
      }
    }
  }

  Future<void> goToEditProfile(BuildContext context) async {
    final dynamic needUpdateInfo = await context.push(
        route: FortunicaEditProfile(isAccountTimeout: state.isTimeout));

    if (needUpdateInfo is bool && needUpdateInfo == true) {
      refreshUserinfo();
    }
  }

  void goToAdvisorPreview(BuildContext context) {
    context.push(
        route: FortunicaAdvisorPreview(isAccountTimeout: state.isTimeout));
  }

  Future<void> openSettingsUrl(BuildContext context) async {
    if (!await launchUrl(
      _url,
      mode: LaunchMode.externalApplication,
    )) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not launch $_url'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void closeErrorWidget() {
    _mainCubit.clearErrorMessage();
  }
}
