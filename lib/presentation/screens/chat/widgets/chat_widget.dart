import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/data/models/chats/chat_item.dart';

abstract class ChatWidget extends StatelessWidget {
  final ChatItem item;

  const ChatWidget({
    super.key,
    required this.item,
  });

  T getter<T>({
    required T question,
    required T answer,
  }) =>
      item.isAnswer ? answer : question;

  DateTime get createdAt =>
      DateTime.tryParse(item.createdAt ?? '') ?? DateTime.now();

  EdgeInsetsGeometry get paddingItem => getter(
        question: const EdgeInsets.fromLTRB(12.0, 4.0, 48.0, 4.0),
        answer: const EdgeInsets.fromLTRB(48.0, 4.0, 12.0, 4.0),
      );

  Color get colorItem => getter(
        question: Get.theme.canvasColor,
        answer: Get.theme.primaryColor,
      );
}
