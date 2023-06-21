import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'focused_menu_state.freezed.dart';

@freezed
class FocusedMenuState with _$FocusedMenuState {
  const factory FocusedMenuState({
    @Default([]) List<Emoji> recentEmojis,
  }) = _FocusedMenuState;
}
