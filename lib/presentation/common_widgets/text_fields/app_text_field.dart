import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String errorText;
  final FocusNode focusNode;
  final FocusNode? nextFocusNode;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final bool isPassword;
  final bool isBig;

  const AppTextField({
    Key? key,
    required this.controller,
    required this.label,
    required this.focusNode,
    this.nextFocusNode,
    this.textInputType,
    this.textInputAction,
    this.isPassword = false,
    this.isBig = false,
    this.errorText = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Get.textTheme.labelMedium),
        const SizedBox(
          height: 4.0,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
            color: errorText.isNotEmpty
                ? Get.theme.errorColor
                : focusNode.hasPrimaryFocus
                    ? Get.theme.primaryColor
                    : Get.theme.hintColor,
          ),
          child: Container(
            margin: const EdgeInsets.fromLTRB(1.0, 1.0, 1.0, 2.0),
            height: (isBig ? 144.0 : AppConstants.textFieldsHeight) - 3,
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(AppConstants.buttonRadius - 1),
              color: Get.theme.canvasColor,
            ),
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              keyboardType: textInputType,
              textInputAction: textInputAction,
              onSubmitted: (_) {
                FocusScope.of(context).requestFocus(nextFocusNode);
              },
              decoration: InputDecoration(
                contentPadding: isBig
                    ? const EdgeInsets.all(12.0)
                    : const EdgeInsets.symmetric(horizontal: 12.0),
              ),
              maxLines: isBig ? 10 : 1,
              style: Get.textTheme.bodyMedium,
            ),
          ),
        ),
        if (errorText.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              errorText,
              style: Get.textTheme.bodySmall
                  ?.copyWith(color: Get.theme.errorColor),
            ),
          )
      ],
    );
  }
}
