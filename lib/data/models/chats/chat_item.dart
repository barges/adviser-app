import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_advisor_interface/data/models/chats/attachment.dart';
import 'package:shared_advisor_interface/data/models/chats/client_information.dart';
import 'package:shared_advisor_interface/data/models/enums/attachment_type.dart';
import 'package:shared_advisor_interface/data/models/enums/chat_item_status_type.dart';
import 'package:shared_advisor_interface/data/models/enums/message_content_type.dart';
import 'package:shared_advisor_interface/data/models/enums/chat_item_type.dart';
import 'package:shared_advisor_interface/data/models/enums/sessions_types.dart';

part 'chat_item.freezed.dart';
part 'chat_item.g.dart';

@freezed
class ChatItem with _$ChatItem {
  const ChatItem._();

  @JsonSerializable(includeIfNull: false)
  const factory ChatItem({
    ChatItemType? type,
    ChatItemType? questionType,
    SessionsTypes? ritualIdentifier,
    ChatItemStatusType? status,
    String? clientName,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? content,
    @JsonKey(name: '_id') final String? id,
    ClientInformation? clientInformation,
    List<Attachment>? attachments,
    List<ChatItemType>? unansweredTypes,
    String? clientID,
    int? unansweredCount,
    @Default(false) bool isAnswer,
    @Default(true) bool isSent,
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
        getAttachment(n)!.mime!.contains(AttachmentType.audio.name)) {
      return getAttachment(n)!.url;
    }
    return null;
  }

  String? getImageUrl(int n) {
    if (isMedia &&
        getAttachment(n) != null &&
        getAttachment(n)!.mime!.contains(AttachmentType.image.name)) {
      return getAttachment(n)!.url;
    }
    return null;
  }

  Duration getDuration(int n) {
    if (getAttachment(n) != null &&
        getAttachment(n)!.meta != null &&
        getAttachment(n)!.meta!.duration != null) {
      return Duration(seconds: getAttachment(n)!.meta!.duration!.toInt());
    }
    return const Duration();
  }

  bool get isMedia => attachments != null && attachments!.isNotEmpty;
}
