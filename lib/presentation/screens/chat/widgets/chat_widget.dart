import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/data/models/chats/questions_type.dart';
import 'package:shared_advisor_interface/data/models/reports_endpoint/sessions_type.dart';

abstract class ChatWidget extends StatelessWidget {
  final bool isQuestion;
  final QuestionsType type;
  final DateTime createdAt;
  final SessionsTypes? ritualIdentifier;

  const ChatWidget({
    super.key,
    required this.isQuestion,
    required this.type,
    required this.createdAt,
    this.ritualIdentifier,
  });

  T getter<T>({
    required T question,
    required T answer,
  }) =>
      isQuestion ? question : answer;
}
