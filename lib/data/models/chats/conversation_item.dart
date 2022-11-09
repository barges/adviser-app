import 'package:shared_advisor_interface/data/models/chats/attachment.dart';
import 'package:shared_advisor_interface/data/models/enums/questions_type.dart';
import 'package:shared_advisor_interface/data/models/enums/sessions_type.dart';

abstract class ConversationItem {
  List<Attachment>? get attachments;
  String? get createdAt;
  String? get content;
  ChatItemType? get type;
  SessionsTypes? get ritualIdentifier;
}
