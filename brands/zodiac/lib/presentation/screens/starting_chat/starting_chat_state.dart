import 'package:freezed_annotation/freezed_annotation.dart';

part 'starting_chat_state.freezed.dart';

@freezed
class StartingChatState with _$StartingChatState {
  const factory StartingChatState({
    String? adviceTip,
  }) = _StartingChatState;
}
