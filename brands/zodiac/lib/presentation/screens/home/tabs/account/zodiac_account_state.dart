import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zodiac/data/models/app_success/app_success.dart';
import 'package:zodiac/data/models/settings/phone.dart';
import 'package:zodiac/data/models/user_info/daily_coupon_info.dart';
import 'package:zodiac/data/models/user_info/user_balance.dart';
import 'package:zodiac/data/models/user_info/user_details.dart';

part 'zodiac_account_state.freezed.dart';

@freezed
class ZodiacAccountState with _$ZodiacAccountState {
  const factory ZodiacAccountState({
    UserDetails? userInfo,
    int? reviewsCount,
    Phone? phone,
    @Default(false) bool callsEnabled,
    @Default(false) bool chatsEnabled,
    @Default(false) bool randomCallsEnabled,
    @Default(true) bool userStatusOnline,
    @Default(UserBalance(
      balance: 0.0,
      currency: '\$',
    ))
    userBalance,
    @Default('') String errorMessage,
    @Default(0) int unreadedNotificationsCount,
    List<DailyCouponInfo>? dailyCoupons,
    @Default(0) int dailyCouponsLimit,
    @Default(false) bool dailyCouponsEnabled,
    @Default(false) bool dailyRenewalEnabled,
    @Default(true) bool couponsSetEqualPrevious,
    @Default(EmptySuccess()) AppSuccess appSuccess,
  }) = _ZodiacAccountState;
}
