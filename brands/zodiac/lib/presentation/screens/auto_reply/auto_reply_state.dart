import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zodiac/data/models/chat/private_message_model.dart';
import 'package:zodiac/presentation/screens/auto_reply/auto_reply_constants.dart';

part 'auto_reply_state.freezed.dart';

@freezed
class AutoReplyState with _$AutoReplyState {
  const factory AutoReplyState({
    @Default(AutoReplyConstants.time) String time,
    @Default(AutoReplyConstants.timeFrom) String timeFrom,
    @Default(AutoReplyConstants.timeTo) String timeTo,
    List<PrivateMessageModel>? messages,
    bool? replyEnabled,
    int? selectedMessageId,
    @Default(false) bool dataFetched,
  }) = _AutoReplyState;
}
