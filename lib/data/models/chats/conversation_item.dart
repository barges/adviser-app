import 'package:shared_advisor_interface/data/models/chats/attachment.dart';
import 'package:shared_advisor_interface/data/models/chats/questions_type.dart';
import 'package:shared_advisor_interface/data/models/reports_endpoint/sessions_type.dart';

abstract class ConversationItem {
  List<Attachment>? get attachments;
  String? get createdAt;
  String? get content;
  QuestionsType? get type;
  SessionsTypes? get ritualIdentifier;
}
