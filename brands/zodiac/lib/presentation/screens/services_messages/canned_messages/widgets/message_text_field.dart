import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/themes/app_colors.dart';
import 'package:zodiac/presentation/common_widgets/text_fields/app_text_field.dart';

const maximumMessageSymbols = 280;

class MessageTextField extends StatelessWidget {
  final String title;
  final String? note;
  final TextEditingController? controller;
  const MessageTextField({
    super.key,
    required this.title,
    this.note,
    this.controller,
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
              child: Text(
                '0 / $maximumMessageSymbols',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 14.0,
                  color: AppColors.online,
                ),
              ),
            )
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
