import 'package:flutter/material.dart';
import 'package:zodiac/zodiac_extensions.dart';

class StartChatMessageWidget extends StatelessWidget {
  final String title;
  final DateTime? date;

  const StartChatMessageWidget({
    Key? key,
    required this.title,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Divider(
            height: 1.0,
            color: theme.shadowColor,
          ),
        ),
        Container(
          height: 18.0,
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
          ),
          margin: const EdgeInsets.symmetric(vertical: 4.0,),
          child: Center(
            child: Text(
              '$title: ${date?.chatListTime ?? ''}',
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 12.0,
                color: theme.shadowColor,
              ),
            ),
          ),
        ),
        Expanded(
          child: Divider(
            height: 1.0,
            color: theme.shadowColor,
          ),
        ),
      ],
    );
  }
}
