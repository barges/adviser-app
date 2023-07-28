import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:shared_advisor_interface/infrastructure/di/brand_manager.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.gr.dart';
import 'package:shared_advisor_interface/services/connectivity_service.dart';
import 'package:shared_advisor_interface/services/push_notification/push_notification_manager.dart';
import 'package:zodiac/data/cache/zodiac_caching_manager.dart';
import 'package:zodiac/data/models/app_success/app_success.dart';
import 'package:zodiac/data/models/app_success/ui_success_type.dart';
import 'package:zodiac/data/models/coupons/coupon_info.dart';
import 'package:zodiac/data/models/enums/zodiac_user_status.dart';
import 'package:zodiac/data/models/settings/phone.dart';
import 'package:zodiac/data/models/user_info/category_info.dart';
import 'package:zodiac/data/models/user_info/detailed_user_info.dart';
import 'package:zodiac/data/models/user_info/user_balance.dart';
import 'package:zodiac/data/models/user_info/user_details.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';
import 'package:zodiac/data/network/requests/notifications_request.dart';
import 'package:zodiac/data/network/requests/price_settings_request.dart';
import 'package:zodiac/data/network/requests/send_push_token_request.dart';
import 'package:zodiac/data/network/requests/set_daily_coupons_request.dart';
import 'package:zodiac/data/network/requests/settings_request.dart';
import 'package:zodiac/data/network/requests/update_enabled_request.dart';
import 'package:zodiac/data/network/requests/update_random_call_enabled_request.dart';
import 'package:zodiac/data/network/requests/update_user_status_request.dart';
import 'package:zodiac/data/network/responses/base_response.dart';
import 'package:zodiac/data/network/responses/daily_coupons_response.dart';
import 'package:zodiac/data/network/responses/expert_details_response.dart';
import 'package:zodiac/data/network/responses/notifications_response.dart';
import 'package:zodiac/data/network/responses/price_settings_response.dart';
import 'package:zodiac/data/network/responses/settings_response.dart';
import 'package:zodiac/data/network/responses/specializations_response.dart';
import 'package:zodiac/domain/repositories/zodiac_coupons_repository.dart';
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
  final ZodiacCouponsRepository _couponsRepository;

  StreamSubscription? _currentBrandSubscription;
  StreamSubscription<bool>? _pushTokenConnectivitySubscription;
  StreamSubscription<bool>? _getSettingsConnectivitySubscription;
  bool? isPushNotificationPermissionGranted;
  String? _siteKey;
  Timer? _successMessageTimer;

  List<CouponInfo> _savedCouponsSet = [];
  bool? _savedCouponsSetCountIsZero;

  late final StreamSubscription<UserBalance> _updateUserBalanceSubscription;
  late final StreamSubscription<bool> _updateAccountSubscription;
  late final StreamSubscription<bool> _updateUnreadNotificationsCounter;
  late final StreamSubscription<bool> _updateAccountSettingsSubscription;

  ZodiacAccountCubit(
    this._brandManager,
    this._mainCubit,
    this._userRepository,
    this._cacheManager,
    this._connectivityService,
    this._pushNotificationManager,
    this._couponsRepository,
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

    _updateAccountSettingsSubscription =
        _mainCubit.updateAccauntSettingsTrigger.listen((_) {
      _getSettings(true);
    });
  }

  @override
  Future<void> close() async {
    _updateUserBalanceSubscription.cancel();
    _pushTokenConnectivitySubscription?.cancel();
    _updateAccountSubscription.cancel();
    _updateUnreadNotificationsCounter.cancel();
    _currentBrandSubscription?.cancel();
    _updateAccountSettingsSubscription.cancel();
    _successMessageTimer?.cancel();
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
      route: ZodiacPhoneNumber(
        siteKey: _siteKey,
        phone: state.phone ?? const Phone(),
      ),
    );
  }

  bool isSiteKey() {
    return _siteKey != null;
  }

  void goToReviews(BuildContext context) {
    context.push(route: const ZodiacReviews());
  }

  Future<void> refreshUserInfo() async {
    try {
      _getSettings();
      if (await _connectivityService.checkConnection()) {
        isPushNotificationPermissionGranted = await _handlePermission(false);

        if (isPushNotificationPermissionGranted == true) {
          _pushNotificationManager.registerForPushNotifications();
          await _sendPushToken();
        }

        await _getAllCategories();

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
          getDailyCoupons();
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

  Future<void> _getSettings([update = false]) async {
    if (_siteKey == null || update) {
      if (await _connectivityService.checkConnection()) {
        final SettingsResponse response =
            await _userRepository.getSettings(SettingsRequest());
        if (response.status == true) {
          _siteKey = response.captcha?.scoreBased?.key;
          emit(state.copyWith(
            phone: response.phone,
          ));
        }
        _getSettingsConnectivitySubscription?.cancel();
      } else {
        _getSettingsConnectivitySubscription =
            _connectivityService.connectivityStream.listen((event) {
          if (event) {
            _getSettings();
          }
        });
      }
    }
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
        _pushTokenConnectivitySubscription?.cancel();
      } else {
        _pushTokenConnectivitySubscription =
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

  Future<void> getDailyCoupons() async {
    DailyCouponsResponse response =
        await _couponsRepository.getDailyCoupons(AuthorizedRequest());
    if (response.status == true) {
      _savedCouponsSet = response.coupons ?? [];

      _savedCouponsSetCountIsZero = _checkCouponsCountIsZero(_savedCouponsSet);

      emit(
        state.copyWith(
          dailyCoupons: response.coupons,
          dailyCouponsLimit: response.limit ?? 0,
          dailyCouponsEnabled: response.isEnabled ?? false,
          dailyRenewalEnabled: response.isRenewalEnabled ?? false,
          couponsSetEqualPrevious: true,
          disableDailyCouponsEnabling: _savedCouponsSetCountIsZero == true,
          disableDailyRenewalEnabling: _savedCouponsSetCountIsZero == true,
        ),
      );
    }
  }

  void setCouponCounter(int? couponId, int count) {
    List<CouponInfo> dailyCoupons = List.of(state.dailyCoupons ?? []);
    if (dailyCoupons.isNotEmpty) {
      int index =
          dailyCoupons.indexWhere((element) => element.couponId == couponId);
      dailyCoupons[index] = dailyCoupons[index].copyWith(count: count);

      bool dailyCouponsCountIsZero = _checkCouponsCountIsZero(dailyCoupons);

      emit(state.copyWith(
        dailyCoupons: List.of(dailyCoupons),
        couponsSetEqualPrevious: checkCouponsSetEqualPrevious(dailyCoupons),
        disableDailyRenewalEnabling:
            dailyCouponsCountIsZero && _savedCouponsSetCountIsZero == true,
      ));
    }
  }

  void onDailyCouponCheckboxChanged(int? couponId, bool value) {
    List<CouponInfo> dailyCoupons = List.of(state.dailyCoupons ?? []);
    if (dailyCoupons.isNotEmpty) {
      int index =
          dailyCoupons.indexWhere((element) => element.couponId == couponId);
      if (value) {
        dailyCoupons[index] = dailyCoupons[index].copyWith(count: 1);
      } else {
        dailyCoupons[index] = dailyCoupons[index].copyWith(count: 0);
      }

      bool dailyCouponsCountIsZero = _checkCouponsCountIsZero(dailyCoupons);

      emit(state.copyWith(
        dailyCoupons: List.of(dailyCoupons),
        couponsSetEqualPrevious: checkCouponsSetEqualPrevious(dailyCoupons),
        disableDailyRenewalEnabling:
            dailyCouponsCountIsZero && _savedCouponsSetCountIsZero == true,
      ));
    }
  }

  Future<void> saveDailyCouponsSet() async {
    try {
      List<CouponInfo>? dailyCoupons = state.dailyCoupons;

      if (dailyCoupons != null) {
        List<int> couponIds = [];

        for (CouponInfo element in dailyCoupons) {
          if (element.couponId != null &&
              element.count != null &&
              element.count! > 0) {
            couponIds.addAll(List.filled(element.count!, element.couponId!));
          }
        }

        final BaseResponse response = await _couponsRepository
            .setDailyCoupons(SetDailyCouponsRequest(coupons: couponIds));

        if (response.status == true) {
          _savedCouponsSet = dailyCoupons;
          emit(state.copyWith(
            couponsSetEqualPrevious: true,
            appSuccess:
                UISuccess(UISuccessMessagesType.dailyCouponsSetUpSuccessful),
            disableDailyCouponsEnabling: false,
          ));
          _successMessageTimer =
              Timer(const Duration(seconds: 10), clearSuccessMessage);
        }
      }
    } catch (e) {
      logger.d(e);
    }
  }

  Future<void> updateDailyCouponsEnabled(bool value) async {
    final BaseResponse response = await _couponsRepository
        .updateEnableDailyCoupons(UpdateEnabledRequest(isEnabled: value));

    if (response.status == true) {
      emit(state.copyWith(dailyCouponsEnabled: value));
    }
  }

  Future<void> updateDailyCouponsRenewalEnabled(bool value) async {
    final BaseResponse response =
        await _couponsRepository.updateEnableDailyCouponsRenewal(
            UpdateEnabledRequest(isEnabled: value));

    if (response.status == true) {
      emit(state.copyWith(dailyRenewalEnabled: value));
    }
  }

  bool checkCouponsSetEqualPrevious(List<CouponInfo> dailyCoupons) {
    return dailyCoupons.equals(_savedCouponsSet);
  }

  void clearSuccessMessage() {
    if (state.appSuccess is! EmptySuccess) {
      emit(state.copyWith(appSuccess: const EmptySuccess()));
    }
  }

  bool _checkCouponsCountIsZero(List<CouponInfo> dailyCoupons) {
    bool couponsCountIsZero = true;
    for (CouponInfo element in dailyCoupons) {
      if (element.count != null && element.count! > 0) {
        couponsCountIsZero = false;
        break;
      }
    }
    return couponsCountIsZero;
  }
}
