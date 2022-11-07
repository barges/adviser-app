import 'dart:ffi';

import 'package:equatable/equatable.dart';
//import 'package:json_annotation/json_annotation.dart';
import 'package:shared_advisor_interface/data/models/chats/answer.dart';
import 'package:shared_advisor_interface/data/models/chats/attachment.dart';
import 'package:shared_advisor_interface/data/models/chats/conversation_item.dart';
import 'package:shared_advisor_interface/data/models/chats/media_type.dart';
import 'package:shared_advisor_interface/data/models/chats/question.dart';

//part 'message.g.dart';

//@JsonSerializable(genericArgumentFactories: true)
class Message<T extends ConversationItem> extends Equatable {
  final T data;

  const Message(
    this.data,
  );

  bool get isQuestion => data is Question;

  bool get isAnswer => data is Answer;

  bool get isMedia => data.attachments != null && data.attachments!.isNotEmpty;

  bool get isQuestionMedia => isQuestion && isMedia;

  bool get isAnswerMedia => isAnswer && isMedia;

  Attachment? get attachment1 {
    if (isMedia) {
      return data.attachments![0];
    }
    return null;
  }

  Attachment? get attachment2 {
    if (isMedia && data.attachments!.length == 2) {
      return data.attachments![0];
    }
    return null;
  }

  String? get audioUrl {
    if (!isMedia) {
      return null;
    }
    if (attachment1!.mime!.contains(MediaType.audio.name)) {
      return data.attachments![0].url;
    }
    if (attachment2 != null &&
        attachment2!.mime!.contains(MediaType.audio.name)) {
      return data.attachments![0].url;
    }
    return null;
  }

  String? get imageUrl {
    if (!isMedia) {
      return null;
    }
    if (attachment1!.mime!.contains(MediaType.image.name)) {
      return data.attachments![0].url;
    }
    if (attachment2 != null &&
        attachment2!.mime!.contains(MediaType.image.name)) {
      return data.attachments![1].url;
    }
    return null;
  }

  bool get isAudio => audioUrl != null;

  Duration? get duration {
    if (isAudio) {
      if (attachment1!.meta['duration'] != null) {
        return Duration(seconds: attachment1!.meta['duration'].toInt());
      }

      if (attachment2 != null && attachment2!.meta['duration'] != null) {
        return Duration(seconds: attachment2!.meta['duration'].toInt());
      }

      return const Duration();
    }

    return null;
  }

  /*factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  Map<String, dynamic> toJson() => _$MessageToJson(this);*/

  @override
  List<Object?> get props => [data];
}
