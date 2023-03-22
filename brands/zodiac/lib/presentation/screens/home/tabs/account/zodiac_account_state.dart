import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zodiac/data/models/user_info/user_balance.dart';
import 'package:zodiac/data/models/user_info/user_details.dart';

part 'zodiac_account_state.freezed.dart';

@freezed
class ZodiacAccountState with _$ZodiacAccountState {
  const factory ZodiacAccountState({
    UserDetails? userInfo,
    int? reviewsCount,
    @Default(false)
        bool callsEnabled,
    @Default(false)
        bool chatsEnabled,
    @Default(false)
        bool randomCallsEnabled,
    @Default(true)
        bool userStatusOnline,
    @Default(UserBalance(
      balance: 0.0,
      currency: '\$',
    ))
        userBalance,
    @Default('')
        String errorMessage,
    @Default(0)
        int unreadedNotificationsCount,
  }) = _ZodiacAccountState;
}
