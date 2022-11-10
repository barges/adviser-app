import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatTextAreaWidget extends StatelessWidget {
  final String? content;
  final Color color;
  const ChatTextAreaWidget({
    super.key,
    required this.color,
    this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      content ?? '',
      style: Get.textTheme.bodySmall?.copyWith(
        color: color,
        fontSize: 15.0,
      ),
    );
  }
}
