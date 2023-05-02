import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zodiac/data/models/enums/zodiac_user_status.dart';

part 'home_state.freezed.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    @Default(0) int tabPositionIndex,
    @Default(ZodiacUserStatus.offline) ZodiacUserStatus userStatus,
    int? articlesUnreadCount,
    int? chatsUnreadCount,
  }) = _HomeState;
}
