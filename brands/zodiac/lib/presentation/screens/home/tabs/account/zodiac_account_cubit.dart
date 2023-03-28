import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.gr.dart';
import 'package:zodiac/data/cache/zodiac_caching_manager.dart';
import 'package:zodiac/data/models/enums/zodiac_user_status.dart';
import 'package:zodiac/data/models/user_info/detailed_user_info.dart';
import 'package:zodiac/data/models/user_info/user_balance.dart';
import 'package:zodiac/data/models/user_info/user_details.dart';
import 'package:zodiac/data/network/requests/expert_details_request.dart';
import 'package:zodiac/data/network/requests/notifications_request.dart';
import 'package:zodiac/data/network/requests/price_settings_request.dart';
import 'package:zodiac/data/network/requests/update_random_call_enabled_request.dart';
import 'package:zodiac/data/network/requests/update_user_status_request.dart';
import 'package:zodiac/data/network/responses/base_response.dart';
import 'package:zodiac/data/network/responses/expert_details_response.dart';
import 'package:zodiac/data/network/responses/notifications_response.dart';
import 'package:zodiac/data/network/responses/price_settings_response.dart';
import 'package:zodiac/domain/repositories/zodiac_user_repository.dart';
import 'package:zodiac/presentation/screens/home/tabs/account/zodiac_account_state.dart';
import 'package:zodiac/zodiac_main_cubit.dart';

class ZodiacAccountCubit extends Cubit<ZodiacAccountState> {
  final ZodiacMainCubit _mainCubit;
  final ZodiacUserRepository _userRepository;
  final ZodiacCachingManager _cacheManager;

  late final StreamSubscription<UserBalance> _updateUserBalanceSubscription;
  late final StreamSubscription<bool> _updateAccountSubscription;

  ZodiacAccountCubit(
    this._mainCubit,
    this._userRepository,
    this._cacheManager,
  ) : super(const ZodiacAccountState()) {
    refreshUserInfo();
    _updateUserBalanceSubscription =
        _mainCubit.userBalanceUpdateTrigger.listen((value) {
      emit(state.copyWith(userBalance: value));
    });

    _updateAccountSubscription = _mainCubit.accountUpdateTrigger.listen(
      (value) {
        refreshUserInfo();
      },
    );
  }

  @override
  Future<void> close() async {
    _updateUserBalanceSubscription.cancel();
    _updateAccountSubscription.cancel();
    super.close();
  }

  void goToNotifications(BuildContext context) {
    context.push(
      route: const ZodiacNotifications(),
    );
  }

  void goToReviews(BuildContext context) {
    context.push(route: const ZodiacReviews());
  }

  Future<void> refreshUserInfo() async {
    try {
      int? userId = _cacheManager.getUid();
      logger.d('GET INFO');
      logger.d(userId);
      if (userId != null) {
        ExpertDetailsResponse response = await _userRepository
            .getDetailedUserInfo(ExpertDetailsRequest(expertId: userId));
        if (response.errorCode == 0) {
          DetailedUserInfo? userInfo = response.result;
          UserDetails? userDetails = userInfo?.details;

          _cacheManager.saveDetailedUserInfo(userInfo);
          _cacheManager.saveUserStatus(userDetails?.status);
          emit(state.copyWith(
            userInfo: userDetails,
            reviewsCount: userInfo?.reviews?.count,
            chatsEnabled: userDetails?.chatEnabled == 1,
            callsEnabled: userDetails?.callEnabled == 1,
            randomCallsEnabled: userDetails?.randomCallEnabled == 1,
            userStatusOnline: userDetails?.status == ZodiacUserStatus.online,
          ));

          NotificationsResponse notificationsResponse =
              await _userRepository.getNotificationsList(
            NotificationsRequest(count: 0, offset: 0),
          );
          if (notificationsResponse.errorCode == 0) {
            emit(state.copyWith(
                unreadedNotificationsCount:
                    notificationsResponse.unreadedCount ?? 0));
          } else {
            _updateErrorMessage(notificationsResponse.getErrorMessage());
          }
        } else {
          _updateErrorMessage(response.getErrorMessage());
        }
      }
    } catch (e) {
      logger.d(e);
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
