// ignore_for_file: invalid_annotation_target

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_advisor_interface/data/models/chats/attachment.dart';
import 'package:shared_advisor_interface/data/models/chats/client_information.dart';
import 'package:shared_advisor_interface/data/models/enums/attachment_type.dart';
import 'package:shared_advisor_interface/data/models/enums/chat_item_status_type.dart';
import 'package:shared_advisor_interface/data/models/enums/message_content_type.dart';
import 'package:shared_advisor_interface/data/models/enums/chat_item_type.dart';
import 'package:shared_advisor_interface/data/models/enums/sessions_types.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/extensions.dart';

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
    DateTime? takenDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? startAnswerDate,
    String? content,
    @JsonKey(name: '_id') String? id,
    ClientInformation? clientInformation,
    @JsonKey(fromJson: _attachmentFromJson) List<Attachment>? attachments,
    List<ChatItemType>? unansweredTypes,
    String? clientID,
    String? ritualID,
    String? lastQuestionId,
    int? unansweredCount,
    String? storyID,
    @JsonKey(ignore: true) @Default(false) bool isActive,
    @JsonKey(ignore: true) @Default(false) bool isAnswer,
    @JsonKey(ignore: true) @Default(true) bool isSent,
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

  String getUnansweredMessage(BuildContext context) {
    String? resultMessage;
    if (unansweredCount != null && unansweredCount! > 1) {
      resultMessage = S
          .of(context)
          .youHaveAFewActiveSessions;
    } else {
      resultMessage = unansweredTypes?.firstOrNull?.unAnsweredMessage(context);
    }
    resultMessage ??= '';
    return resultMessage;
  }

  bool get isAudio =>
      attachments?.isNotEmpty == true && attachments!
          .any((element) => element.type == AttachmentType.audio);
}

List<Attachment>? _attachmentFromJson(json) => (json as List<dynamic>?)
    ?.map((e) => Attachment.fromJson(e as Map<String, dynamic>))
    .toList()
  ?..sort((a, b) {
    if (a.type == AttachmentType.image && b.type == AttachmentType.audio) {
      return -1;
    } else {
      return 1;
    }
  });
