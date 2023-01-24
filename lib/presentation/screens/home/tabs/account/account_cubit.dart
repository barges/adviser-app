import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/data/cache/caching_manager.dart';
import 'package:shared_advisor_interface/data/models/enums/fortunica_user_status.dart';
import 'package:shared_advisor_interface/data/models/enums/markets_type.dart';
import 'package:shared_advisor_interface/data/models/user_info/localized_properties/property_by_language.dart';
import 'package:shared_advisor_interface/data/models/user_info/user_info.dart';
import 'package:shared_advisor_interface/data/network/requests/push_enable_request.dart';
import 'package:shared_advisor_interface/data/network/requests/set_push_notification_token_request.dart';
import 'package:shared_advisor_interface/data/network/requests/update_user_status_request.dart';
import 'package:shared_advisor_interface/domain/repositories/user_repository.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/resources/app_routes.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/account/account_state.dart';
import 'package:shared_advisor_interface/presentation/services/check_permission_service.dart';
import 'package:shared_advisor_interface/presentation/services/connectivity_service.dart';
import 'package:shared_advisor_interface/presentation/services/push_notification/push_notification_manager.dart';
import 'package:url_launcher/url_launcher.dart';

bool _pushTokenIsSent = false;

class AccountCubit extends Cubit<AccountState> {
  final TextEditingController commentController = TextEditingController();
  final FocusNode commentNode = FocusNode();

  final MainCubit _mainCubit;
  final UserRepository _userRepository;
  final ConnectivityService _connectivityService;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final CheckPermissionService _checkPermissionService;
  final BuildContext context;

  final CachingManager _cacheManager;

  final PushNotificationManager _pushNotificationManager;

  final Uri _url = Uri.parse(AppConstants.webToolUrl);

  late final VoidCallback disposeListen;
  late final StreamSubscription<bool> _appOnResumeSubscription;
  StreamSubscription<bool>? _connectivitySubscription;
  late bool isPushNotificationPermissionGranted;

  AccountCubit(
    this._cacheManager,
    this._mainCubit,
    this._userRepository,
    this._pushNotificationManager,
    this._connectivityService,
    this._checkPermissionService,
    this.context,
  ) : super(const AccountState()) {
    disposeListen = _cacheManager.listenUserProfile((value) {
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
    refreshUserinfo();

    _appOnResumeSubscription = _mainCubit.changeAppLifecycleStream.listen(
      (value) async {
        if (value) {
          final bool newPushPermissionsValue = await _checkPermissionService
              .handlePermission(context, PermissionType.notification);
          if (newPushPermissionsValue) {
            _pushNotificationManager.registerForPushNotifications();
          }
          if (isPushNotificationPermissionGranted != newPushPermissionsValue) {
            isPushNotificationPermissionGranted = newPushPermissionsValue;
            await refreshUserinfo();
          }
        }
      },
    );
  }

  @override
  Future<void> close() async {
    _appOnResumeSubscription.cancel();
    _connectivitySubscription?.cancel();
    disposeListen.call();
    commentController.dispose();
    commentNode.dispose();
    return super.close();
  }

  Future<void> refreshUserinfo() async {
    if (await _connectivityService.checkConnection()) {
      int milliseconds = 0;

      isPushNotificationPermissionGranted = await _checkPermissionService
          .handlePermission(context, PermissionType.notification);
      if (isPushNotificationPermissionGranted) {
        _pushNotificationManager.registerForPushNotifications();
      }

      final UserInfo userInfo = await _userRepository.getUserInfo();

      if (isPushNotificationPermissionGranted) {
        await _sendPushToken();
      }

      await _saveUserInfo(userInfo);

      final DateTime? profileUpdatedAt =
          _cacheManager.getUserStatus()?.profileUpdatedAt;

      if (profileUpdatedAt != null) {
        DateTime currentTime = DateTime.now().toUtc();
        currentTime = currentTime.add(const Duration(seconds: 15));
        milliseconds = currentTime.difference(profileUpdatedAt).inMilliseconds;
      }

      emit(
        state.copyWith(
          userProfile: _cacheManager.getUserProfile(),
          enableNotifications: (userInfo.pushNotificationsEnabled ?? false) &&
              isPushNotificationPermissionGranted,
          millisecondsForTimer: milliseconds > 0
              ? AppConstants.millisecondsInHour - milliseconds
              : milliseconds,
        ),
      );
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

    if (userInfo.contracts?.updates?.isNotEmpty == true) {
      await _cacheManager.saveUserStatus(userInfo.status?.copyWith(
        status: FortunicaUserStatus.legalBlock,
      ));
    } else {
      if (checkPropertiesMapIfHasEmpty(userInfo) ||
          userInfo.profile?.profileName?.isNotEmpty != true ||
          userInfo.profile?.profilePictures?.isNotEmpty != true) {
        await _cacheManager.saveUserStatus(userInfo.status?.copyWith(
          status: FortunicaUserStatus.incomplete,
        ));
      } else {
        await _cacheManager.saveUserStatus(userInfo.status);
      }
    }
  }

  Future<UserInfo?> _setPushEnabledForBackend(bool value) async {
    UserInfo? userInfo =
        await _userRepository.setPushEnabled(PushEnableRequest(value: value));

    await _cacheManager.saveUserInfo(userInfo);
    return userInfo;
  }

  Future<void> updateUserStatus({required FortunicaUserStatus status}) async {
    final UpdateUserStatusRequest request = UpdateUserStatusRequest(
      status: status,
      comment: commentController.text,
    );
    await _userRepository.updateUserStatus(request);
    refreshUserinfo();
  }

  Future<void> updateEnableNotificationsValue(bool newValue) async {
    if (newValue) {
      if (isPushNotificationPermissionGranted) {
        await _sendPushToken();
        await _setPushEnabledForBackend(newValue);
        emit(
          state.copyWith(
            enableNotifications: newValue,
          ),
        );
      } else {
        _checkPermissionService.handlePermission(
            context, PermissionType.notification);
      }
    } else {
      await _setPushEnabledForBackend(newValue);
      emit(
        state.copyWith(
          enableNotifications: newValue,
        ),
      );
    }
  }

  Future<void> _sendPushToken() async {
    if (!_pushTokenIsSent) {
      if (await _connectivityService.checkConnection()) {
        String? pushToken = await _firebaseMessaging.getToken();
        if (pushToken != null) {
          final SetPushNotificationTokenRequest request =
              SetPushNotificationTokenRequest(
            pushToken: pushToken,
          );
          _userRepository.sendPushToken(request);
          _pushTokenIsSent = true;
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

  Future<void> goToEditProfile() async {
    final dynamic needUpdateInfo = await Get.toNamed(
      AppRoutes.editProfile,
    );
    if (needUpdateInfo is bool && needUpdateInfo == true) {
      refreshUserinfo();
    }
  }

  void hideTimer() {
    emit(
      state.copyWith(
        millisecondsForTimer: 0,
      ),
    );
  }

  Future<void> openSettingsUrl() async {
    if (!await launchUrl(
      _url,
      mode: LaunchMode.externalApplication,
    )) {
      Get.showSnackbar(GetSnackBar(
        duration: const Duration(seconds: 2),
        message: 'Could not launch $_url',
      ));
    }
  }
}
