import 'package:freezed_annotation/freezed_annotation.dart';

part 'canned_messages_state.freezed.dart';

@freezed
class CannedMessagesState with _$CannedMessagesState {
  const factory CannedMessagesState({
    @Default(0) int selectedCategoryIndex,
    int? editingCannedMessageIndex,
  }) = _CannedMessagesState;
}
