import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/resources/app_icons.dart';

class PasswordFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final TextInputAction? textInputAction;
  final bool showErrorText;
  final bool hiddenPassword;
  final String? errorText;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? clickToHide;
  final FocusNode? focusNode;
  final String? label;

  const PasswordFieldWidget({
    Key? key,
    required this.controller,
    this.textInputAction,
    this.label,
    this.onSubmitted,
    this.clickToHide,
    this.focusNode,
    this.errorText,
    this.showErrorText = false,
    this.hiddenPassword = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Text(label ?? '', style: Get.textTheme.labelMedium),
          ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
            color: showErrorText ? Get.theme.errorColor : Get.theme.hintColor,
          ),
          child: Container(
            margin: const EdgeInsets.fromLTRB(1.0, 1.0, 1.0, 2.0),
            padding: const EdgeInsets.only(bottom: 8.0),
            height: AppConstants.textFieldsHeight - 3,
            decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
            ),
            child: Theme(
              data: Get.theme.copyWith(
                primaryColor: Colors.redAccent,
              ),
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                obscureText: hiddenPassword,
                obscuringCharacter: '*',
                keyboardType: TextInputType.visiblePassword,
                textInputAction: textInputAction,
                onSubmitted: onSubmitted,
                style: Get.textTheme.bodyMedium,
                maxLines: 1,
                decoration: InputDecoration(
                  suffixIcon: GestureDetector(
                    onTap: clickToHide,
                    child: Icon(
                      hiddenPassword
                          ? AppIcons.visibility
                          : AppIcons.visibilityOff,
                      color: Get.iconColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
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
