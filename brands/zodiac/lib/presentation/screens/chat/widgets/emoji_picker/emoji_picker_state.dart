import 'package:freezed_annotation/freezed_annotation.dart';

part 'emoji_picker_state.freezed.dart';

@freezed
class EmojiPickerState with _$EmojiPickerState {
  const factory EmojiPickerState({
    @Default(0) int categoryIndex,
  }) = _EmojiPickerState;
}
