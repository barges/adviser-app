import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/data/models/enums/questions_type.dart';
import 'package:shared_advisor_interface/data/models/enums/sessions_type.dart';

abstract class ChatWidget extends StatelessWidget {
  final bool isQuestion;
  final ChatItemType type;
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
