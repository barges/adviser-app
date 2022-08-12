import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/presentation/resources/app_colors.dart';
import 'package:shared_advisor_interface/presentation/resources/app_text_styles.dart';

class CustomTextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final TextInputAction? textInputAction;
  final TextInputType? textInputType;
  final bool showErrorText;
  final String? errorText;
  final ValueChanged<String>? onSubmitted;
  final FocusNode? focusNode;
  final String? label;

  const CustomTextFieldWidget(
      {Key? key,
      required this.controller,
      this.textInputAction,
      this.textInputType,
      this.label,
      this.showErrorText = false,
      this.onSubmitted,
      this.focusNode,
      this.errorText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Text(label ?? '',
                style: AppTextStyles.titleMedium),
          ),
        Ink(
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Theme.of(context).canvasColor,
          ),
          child: TextField(
              focusNode: focusNode,
              controller: controller,
              keyboardType: textInputType,
              textInputAction: textInputAction,
              onSubmitted: onSubmitted,
              style: AppTextStyles.bodyMedium,
              showCursor: false,
              maxLines: 1,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 1, color: AppColors.highlight)))),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(showErrorText && errorText != null ? errorText! : '',
              style: AppTextStyles.errorTextStyle),
        )
      ],
    );
  }
}
