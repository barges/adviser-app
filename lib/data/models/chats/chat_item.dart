import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_advisor_interface/data/models/chats/attachment.dart';
import 'package:shared_advisor_interface/data/models/chats/client_information.dart';
import 'package:shared_advisor_interface/data/models/chats/media_type.dart';
import 'package:shared_advisor_interface/data/models/enums/message_content_type.dart';
import 'package:shared_advisor_interface/data/models/enums/questions_type.dart';
import 'package:shared_advisor_interface/data/models/enums/sessions_type.dart';

part 'chat_item.freezed.dart';
part 'chat_item.g.dart';

@freezed
class ChatItem with _$ChatItem {
  const ChatItem._();

  @JsonSerializable(includeIfNull: false)
  const factory ChatItem({
    ChatItemType? type,
    SessionsTypes? ritualIdentifier,
    String? clientName,
    String? createdAt,
    String? updatedAt,
    String? content,
    @JsonKey(name: '_id') final String? id,
    ClientInformation? clientInformation,
    List<Attachment>? attachments,
    String? clientID,
  }) = _ChatItem;

  factory ChatItem.fromJson(Map<String, dynamic> json) =>
      _$ChatItemFromJson(json);

  ChatItemContentType get contentType {
    ChatItemContentType? chatItemContentType = ChatItemContentType.text;
    if (attachments != null && attachments!.isNotEmpty) {
      final String content = this.content ?? '';
      if (content.isNotEmpty) {
        if (attachments!.length == 1) {
          chatItemContentType = ChatItemContentType.mediaText;
        } else {
          chatItemContentType = ChatItemContentType.mediaMediaText;
        }
      } else {
        if (attachments!.length == 1) {
          chatItemContentType = ChatItemContentType.media;
        } else {
          chatItemContentType = ChatItemContentType.mediaMedia;
        }
      }
    }
    return chatItemContentType;
  }

  Attachment? getAttachment(int n) {
    if (isMedia && attachments!.length >= n) {
      return attachments![n - 1];
    }
    return null;
  }

  String? getAudioUrl(int n) {
    if (isMedia &&
        getAttachment(n) != null &&
        getAttachment(n)!.mime!.contains(MediaType.audio.name)) {
      return getAttachment(n)!.url;
    }
    return null;
  }

  String? getImageUrl(int n) {
    if (isMedia &&
        getAttachment(n) != null &&
        getAttachment(n)!.mime!.contains(MediaType.image.name)) {
      return getAttachment(n)!.url;
    }
    return null;
  }

  Duration? getDuration(int n) {
    if (getAttachment(n) != null &&
        getAttachment(n)!.meta != null &&
        getAttachment(n)!.meta!.duration != null) {
      return Duration(seconds: getAttachment(n)!.meta!.duration!.toInt());
    }
    return null;
  }

  bool get isQuestionMedia => isQuestion && isMedia;

  bool get isAnswerMedia => isAnswer && isMedia;

  bool get isQuestion => type != ChatItemType.textAnswer;

  bool get isAnswer => type == ChatItemType.textAnswer;

  bool get isMedia => attachments != null && attachments!.isNotEmpty;
}
