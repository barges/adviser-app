import 'package:flutter/material.dart';

class ChatTextAreaWidget extends StatelessWidget {
  final String content;
  final Color color;

  const ChatTextAreaWidget({
    super.key,
    required this.color,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      content,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: color,
            fontSize: 15.0,
          ),
    );
  }
}
