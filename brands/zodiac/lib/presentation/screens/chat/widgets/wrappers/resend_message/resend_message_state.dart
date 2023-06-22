import 'package:freezed_annotation/freezed_annotation.dart';

part 'resend_message_state.freezed.dart';

@freezed
class ResendMessageState with _$ResendMessageState {
  const factory ResendMessageState({
    @Default(false) bool showResendWidget,
  }) = _ChatMessageState;
}
