import 'package:shared_advisor_interface/data/models/chats/answer.dart';
import 'package:shared_advisor_interface/data/models/chats/attachment.dart';
import 'package:shared_advisor_interface/data/models/chats/conversation_item.dart';
import 'package:shared_advisor_interface/data/models/chats/file_extension.dart';
import 'package:shared_advisor_interface/data/models/chats/media_type.dart';
import 'package:shared_advisor_interface/data/models/chats/question.dart';

class Message<T extends ConversationItem> {
  final T data;

  const Message(
    this.data,
  );

  Attachment? get attachment1 {
    if (isMedia) {
      return data.attachments![0];
    }
    return null;
  }

  Attachment? get attachment2 {
    if (isMedia && data.attachments!.length == 2) {
      return data.attachments![1];
    }
    return null;
  }

  String? get audioUrl {
    if (!isMedia) {
      return null;
    }
    if (attachment1!.mime!.contains(MediaType.audio.name) ||
        attachment1!.mime!.contains(FileExtension.mp4.name)) {
      return attachment1!.url;
    }

    if (attachment2 != null &&
        (attachment2!.mime!.contains(MediaType.audio.name) ||
            attachment2!.mime!.contains(FileExtension.mp4.name))) {
      return attachment2!.url;
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

  Duration? get duration {
    if (isAudio) {
      if (attachment1!.meta!.duration != null) {
        return Duration(seconds: attachment1!.meta!.duration!.toInt());
      }

      if (attachment2 != null && attachment2!.meta!.duration != null) {
        return Duration(seconds: attachment2!.meta!.duration!.toInt());
      }
    }

    return null;
  }

  bool get isQuestionMedia => isQuestion && isMedia;

  bool get isAnswerMedia => isAnswer && isMedia;

  bool get isQuestion => data is Question;

  bool get isAnswer => data is Answer;

  bool get isMedia => data.attachments != null && data.attachments!.isNotEmpty;

  bool get isAudio => audioUrl != null;

  bool get isImage => imageUrl != null;
}
