import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:shared_advisor_interface/infrastructure/di/brand_manager.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.gr.dart';
import 'package:shared_advisor_interface/services/connectivity_service.dart';
import 'package:shared_advisor_interface/services/push_notification/push_notification_manager.dart';
import 'package:zodiac/data/cache/zodiac_caching_manager.dart';
import 'package:zodiac/data/models/enums/zodiac_user_status.dart';
import 'package:zodiac/data/models/user_info/category_info.dart';
import 'package:zodiac/data/models/user_info/detailed_user_info.dart';
import 'package:zodiac/data/models/user_info/user_balance.dart';
import 'package:zodiac/data/models/user_info/user_details.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';
import 'package:zodiac/data/network/requests/notifications_request.dart';
import 'package:zodiac/data/network/requests/price_settings_request.dart';
import 'package:zodiac/data/network/requests/send_push_token_request.dart';
import 'package:zodiac/data/network/requests/settings_request.dart';
import 'package:zodiac/data/network/requests/update_random_call_enabled_request.dart';
import 'package:zodiac/data/network/requests/update_user_status_request.dart';
import 'package:zodiac/data/network/responses/base_response.dart';
import 'package:zodiac/data/network/responses/expert_details_response.dart';
import 'package:zodiac/data/network/responses/notifications_response.dart';
import 'package:zodiac/data/network/responses/price_settings_response.dart';
import 'package:zodiac/data/network/responses/settings_response.dart';
import 'package:zodiac/data/network/responses/specializations_response.dart';
import 'package:zodiac/domain/repositories/zodiac_user_repository.dart';
import 'package:zodiac/presentation/screens/home/tabs/account/zodiac_account_state.dart';
import 'package:zodiac/zodiac.dart';
import 'package:zodiac/zodiac_main_cubit.dart';

class ZodiacAccountCubit extends Cubit<ZodiacAccountState> {
  final BrandManager _brandManager;
  final ZodiacMainCubit _mainCubit;
  final ZodiacUserRepository _userRepository;
  final ZodiacCachingManager _cacheManager;
  final ConnectivityService _connectivityService;
  final PushNotificationManager _pushNotificationManager;
  final Future<bool> Function(bool needShowSettingsAlert) _handlePermission;

  StreamSubscription? _currentBrandSubscription;

  late final StreamSubscription<UserBalance> _updateUserBalanceSubscription;
  StreamSubscription<bool>? _connectivitySubscription;
  bool? isPushNotificationPermissionGranted;
  late final StreamSubscription<bool> _updateAccountSubscription;
  late final StreamSubscription<bool> _updateUnreadNotificationsCounter;

  ZodiacAccountCubit(
    this._brandManager,
    this._mainCubit,
    this._userRepository,
    this._cacheManager,
    this._connectivityService,
    this._pushNotificationManager,
    this._handlePermission,
  ) : super(const ZodiacAccountState()) {
    if (_brandManager.getCurrentBrand().brandAlias == ZodiacBrand.alias) {
      refreshUserInfo();
    } else {
      _currentBrandSubscription =
          _brandManager.listenCurrentBrandStream((value) async {
        if (value.brandAlias == ZodiacBrand.alias) {
          await refreshUserInfo();
          _currentBrandSubscription?.cancel();
        }
      });
    }

    _updateUserBalanceSubscription =
        _mainCubit.userBalanceUpdateTrigger.listen((value) {
      emit(state.copyWith(userBalance: value));
    });

    _updateAccountSubscription = _mainCubit.accountUpdateTrigger.listen(
      (value) {
        refreshUserInfo();
      },
    );

    _updateUnreadNotificationsCounter =
        _mainCubit.unreadNotificationsCounterUpdateTrigger.listen((value) {
      _getUnreadNotificationsCount();
    });
  }

  @override
  Future<void> close() async {
    _updateUserBalanceSubscription.cancel();
    _connectivitySubscription?.cancel();
    _updateAccountSubscription.cancel();
    _updateUnreadNotificationsCounter.cancel();
    _currentBrandSubscription?.cancel();
    super.close();
  }

  void goToNotifications(BuildContext context) {
    context.push(
      route: const ZodiacNotifications(),
    );
  }

  void goToBalanceAndTransactions(BuildContext context) {
    context.push(
      route: ZodiacBalanceAndTransactions(userBalance: state.userBalance),
    );
  }

  void goToPhoneNumber(BuildContext context) {
    context.push(
      route: ZodiacPhoneNumber(phone: state.phone),
    );
  }

  void goToReviews(BuildContext context) {
    context.push(route: const ZodiacReviews());
  }

  Future<void> refreshUserInfo() async {
    try {
      if (await _connectivityService.checkConnection()) {
        isPushNotificationPermissionGranted = await _handlePermission(false);

        if (isPushNotificationPermissionGranted == true) {
          _pushNotificationManager.registerForPushNotifications();
          await _sendPushToken();
        }

        await _getAllCategories();

        await _getSettings();

        ExpertDetailsResponse response =
            await _userRepository.getDetailedUserInfo(AuthorizedRequest());
        if (response.errorCode == 0) {
          DetailedUserInfo? userInfo = response.result;
          UserDetails? userDetails = userInfo?.details;

          _cacheManager.saveDetailedUserInfo(
              userInfo?.copyWith(locales: response.locales));
          _cacheManager.saveUserStatus(userDetails?.status);
          emit(state.copyWith(
            userInfo: userDetails,
            reviewsCount: userInfo?.reviews?.count,
            chatsEnabled: userDetails?.chatEnabled == 1,
            callsEnabled: userDetails?.callEnabled == 1,
            randomCallsEnabled: userDetails?.randomCallEnabled == 1,
            userStatusOnline: userDetails?.status == ZodiacUserStatus.online,
          ));

          _getUnreadNotificationsCount();
        } else {
          _updateErrorMessage(response.getErrorMessage());
        }
      }
    } catch (e) {
      logger.d(e);
    }
  }

  Future<void> _getUnreadNotificationsCount() async {
    try {
      NotificationsResponse notificationsResponse =
          await _userRepository.getNotificationsList(
        NotificationsRequest(count: 1, offset: 0),
      );
      if (notificationsResponse.errorCode == 0) {
        emit(state.copyWith(
            unreadedNotificationsCount:
                notificationsResponse.unreadCount ?? 0));
      } else {
        _updateErrorMessage(notificationsResponse.getErrorMessage());
      }
    } catch (e) {
      logger.d(e);
    }
  }

  Future<void> _getAllCategories() async {
    final SpecializationsResponse response =
        await _userRepository.getSpecializations(AuthorizedRequest());
    final List<CategoryInfo>? responseCategories = response.result;
    if (responseCategories != null) {
      final List<CategoryInfo> categories =
          CategoryInfo.normalizeList(responseCategories);

      _cacheManager.saveAllCategories(categories);
    }
  }

  Future<void> _getSettings() async {
    final SettingsResponse response =
        await _userRepository.getSettings(SettingsRequest());
    emit(state.copyWith(
      phone: response.phone,
    ));
  }

  Future<void> _sendPushToken() async {
    if (!_cacheManager.pushTokenIsSent) {
      if (await _connectivityService.checkConnection()) {
        String? pushToken = await _pushNotificationManager.getToken();
        if (pushToken != null) {
          final SendPushTokenRequest request = SendPushTokenRequest(
            registrationId: pushToken,
          );
          final BaseResponse response =
              await _userRepository.sendPushToken(request);
          if (response.status == true) {
            _cacheManager.pushTokenIsSent = true;
          }
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

  Future<void> updateChatsEnabled(bool value) async {
    try {
      PriceSettingsRequest request = PriceSettingsRequest(
        saveForm: 1,
        chatEnabled: value ? 1 : 0,
        chatFee: state.userInfo?.chatFee,
      );

      PriceSettingsResponse response =
          await _userRepository.setPriceSettings(request);
      if (response.errorCode == 0) {
        emit(state.copyWith(chatsEnabled: value));
      } else {
        _updateErrorMessage(response.getErrorMessage());
      }
    } catch (e) {
      logger.d(e);
    }
  }

  Future<void> updateCallsEnabled(bool value) async {
    try {
      PriceSettingsRequest request = PriceSettingsRequest(
        saveForm: 1,
        callEnabled: value ? 1 : 0,
        callFee: state.userInfo?.callFee,
      );

      PriceSettingsResponse response =
          await _userRepository.setPriceSettings(request);

      if (response.errorCode == 0) {
        emit(state.copyWith(callsEnabled: value));
      } else {
        _updateErrorMessage(response.getErrorMessage());
      }
    } catch (e) {
      logger.d(e);
    }
  }

  Future<void> updateRandomCallsEnabled(bool value) async {
    try {
      BaseResponse response = await _userRepository.updateRandomCallsEnabled(
          UpdateRandomCallEnabledRequest(randomCallEnabled: value));

      if (response.errorCode == 0) {
        emit(state.copyWith(randomCallsEnabled: value));
      } else {
        _updateErrorMessage(response.getErrorMessage());
      }
    } catch (e) {
      logger.d(e);
    }
  }

  Future<void> changeChatsPrice(double value) async {
    try {
      PriceSettingsRequest request = PriceSettingsRequest(
        saveForm: 1,
        chatEnabled: state.chatsEnabled ? 1 : 0,
        chatFee: value,
      );

      PriceSettingsResponse response =
          await _userRepository.setPriceSettings(request);
      if (response.errorCode == 0) {
        emit(
            state.copyWith(userInfo: state.userInfo?.copyWith(chatFee: value)));
      } else {
        _updateErrorMessage(response.getErrorMessage());
      }
    } catch (e) {
      logger.d(e);
    }
  }

  Future<void> changeCallsPrice(double value) async {
    try {
      PriceSettingsRequest request = PriceSettingsRequest(
        saveForm: 1,
        callEnabled: state.callsEnabled ? 1 : 0,
        callFee: value,
      );

      PriceSettingsResponse response =
          await _userRepository.setPriceSettings(request);
      if (response.errorCode == 0) {
        emit(
            state.copyWith(userInfo: state.userInfo?.copyWith(callFee: value)));
      } else {
        _updateErrorMessage(response.getErrorMessage());
      }
    } catch (e) {
      logger.d(e);
    }
  }

  Future<void> updateUserStatus(bool value) async {
    try {
      BaseResponse response = await _userRepository.updateUserStatus(
        UpdateUserStatusRequest(
          status: value
              ? ZodiacUserStatus.online.intFromStatus
              : ZodiacUserStatus.offline.intFromStatus,
        ),
      );
      if (response.errorCode == 0) {
        _cacheManager.saveUserStatus(
            value ? ZodiacUserStatus.online : ZodiacUserStatus.offline);
        emit(state.copyWith(userStatusOnline: value));
      } else {
        _updateErrorMessage(response.getErrorMessage());
      }
    } catch (e) {
      logger.d(e);
    }
  }

  void _updateErrorMessage(String errorMessage) {
    emit(state.copyWith(errorMessage: errorMessage));
  }

  void clearErrorMessage() {
    if (state.errorMessage.isNotEmpty) {
      emit(state.copyWith(errorMessage: ''));
    }
  }
}
