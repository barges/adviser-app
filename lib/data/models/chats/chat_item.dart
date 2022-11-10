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

  Attachment? get attachment1 {
    if (isMedia) {
      return attachments![0];
    }
    return null;
  }

  Attachment? get attachment2 {
    if (isMedia && attachments!.length == 2) {
      return attachments![1];
    }
    return null;
  }

  String? get audioUrl {
    if (!isMedia) {
      return null;
    }
    if (attachment1!.mime!.contains(MediaType.audio.name)) {
      return attachment1!.url;
    }

    if (attachment2 != null &&
        (attachment2!.mime!.contains(MediaType.audio.name))) {
      return attachment2!.url;
    }

    return null;
  }

  String? get imageUrl {
    if (!isMedia) {
      return null;
    }
    if (attachment1!.mime!.contains(MediaType.image.name)) {
      return attachments![0].url;
    }
    if (attachment2 != null &&
        attachment2!.mime!.contains(MediaType.image.name)) {
      return attachments![1].url;
    }
    return null;
  }

  Duration? get duration {
    if (isAudio) {
      if (attachment1!.meta != null && attachment1!.meta!.duration != null) {
        return Duration(seconds: attachment1!.meta!.duration!.toInt());
      }

      if (attachment2 != null &&
          attachment2!.meta != null &&
          attachment2!.meta!.duration != null) {
        return Duration(seconds: attachment2!.meta!.duration!.toInt());
      }
    }

    return null;
  }

  bool get isQuestionMedia => isQuestion && isMedia;

  bool get isAnswerMedia => isAnswer && isMedia;

  bool get isQuestion => type != ChatItemType.textAnswer;

  bool get isAnswer => type == ChatItemType.textAnswer;

  bool get isMedia => attachments != null && attachments!.isNotEmpty;

  bool get isAudio => audioUrl != null;

  bool get isImage => imageUrl != null;
}
