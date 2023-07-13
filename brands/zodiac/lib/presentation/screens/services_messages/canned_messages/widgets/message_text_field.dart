import 'package:flutter/material.dart';
import 'package:zodiac/presentation/common_widgets/text_fields/app_text_field.dart';
import 'package:zodiac/presentation/screens/services_messages/canned_messages/widgets/counter_text_field.dart';

class MessageTextField extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final String? note;
  const MessageTextField({
    super.key,
    required this.title,
    required this.controller,
    this.note,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            AppTextField(
              label: title,
              controller: controller,
              isBig: true,
            ),
            Positioned(
              right: 12.0,
              bottom: 12.0,
              child: CounterTextField(controller: controller),
            ),
          ],
        ),
        if (note != null)
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Text(
              note!,
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 12.0,
                color: theme.shadowColor,
              ),
            ),
          ),
      ],
    );
  }
}
