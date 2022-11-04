import 'package:flutter/material.dart';

abstract class ChatWidget extends StatelessWidget {
  final bool isQuestion;
  const ChatWidget({
    super.key,
    required this.isQuestion,
  });

  T getter<T>({
    required T question,
    required T answer,
  }) =>
      isQuestion ? question : answer;
}
