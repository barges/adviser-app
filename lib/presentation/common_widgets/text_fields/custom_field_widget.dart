import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';

class CustomFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final bool showErrorText;
  final double? height;
  final int? maxLines;
  final String? errorText;
  final ValueChanged<String>? onSubmitted;
  final FocusNode? focusNode;
  final String? label;

  const CustomFieldWidget(
      {Key? key,
      required this.controller,
      this.textInputAction,
      this.keyboardType,
      this.label,
      this.onSubmitted,
      this.focusNode,
      this.errorText,
      this.showErrorText = false,
      this.height,
      this.maxLines=1})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final OutlineInputBorder border = OutlineInputBorder(
        borderSide: BorderSide(
          color: Get.theme.hintColor,
        ),
        borderRadius: BorderRadius.zero);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0, left: 4.0),
            child: Text(label ?? '', style: Get.textTheme.labelMedium),
          ),
        SizedBox(
          height: height ?? AppConstants.textFieldsHeight,
          child: TextField(
              controller: controller,
              focusNode: focusNode,
              keyboardType: keyboardType,
              textInputAction: textInputAction,
              maxLines: maxLines,
              onSubmitted: onSubmitted,
              style: Get.textTheme.bodyMedium,
              decoration: InputDecoration(
                  fillColor: Get.theme.canvasColor,
                  filled: true,
                  border: border,
                  focusedBorder: border,
                  enabledBorder: border,
                  focusedErrorBorder: border)),
        ),
        if (showErrorText)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(errorText ?? '',
                style: Get.textTheme.bodySmall?.copyWith(
                  color: Get.theme.errorColor,
                )),
          )
      ],
    );
  }
}
