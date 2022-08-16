import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/resources/app_icons.dart';

class PasswordFieldWidget extends StatelessWidget {
  final TextInputAction? textInputAction;
  final bool showErrorText;
  final bool hiddenPassword;
  final String? errorText;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onChanged;
  final VoidCallback? clickToHide;
  final FocusNode? focusNode;
  final String? label;

  const PasswordFieldWidget(
      {Key? key,
      this.textInputAction,
      this.label,
      this.showErrorText = false,
      this.hiddenPassword = true,
      this.onSubmitted,
        this.clickToHide,
      this.onChanged,
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
            child: Text(label ?? '', style: Get.textTheme.labelMedium),
          ),
        Ink(
          height: AppConstants.textFieldsHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: Theme.of(context).canvasColor,
          ),
          child: Theme(
            data: Get.theme.copyWith(primaryColor: Colors.redAccent,),
            child: TextField(
              focusNode: focusNode,
              obscureText: hiddenPassword,
              keyboardType: TextInputType.visiblePassword,
              textInputAction: textInputAction,
              onSubmitted: onSubmitted,
              style: Get.textTheme.bodyMedium,
              maxLines: 1,
              onChanged: onChanged,
              decoration: showErrorText
                  ? InputDecoration(
                border: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: Get.theme.errorColor),
                    borderRadius: BorderRadius.circular(8.0)),
                errorBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: Get.theme.errorColor),
                    borderRadius: BorderRadius.circular(8.0)),
                focusedBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: Get.theme.errorColor),
                    borderRadius: BorderRadius.circular(8.0)),
                enabledBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: Get.theme.errorColor),
                    borderRadius: BorderRadius.circular(8.0)),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Get.theme.errorColor),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                suffixIcon: GestureDetector(
                  onTap: clickToHide,
                  child: Icon(hiddenPassword
                      ? AppIcons.visibility
                      : AppIcons.visibilityOff,
                    color: Get.iconColor,),
                ),
              )
                  : InputDecoration(
                suffixIcon: GestureDetector(
                  onTap: clickToHide,
                  child: Icon(hiddenPassword
                      ? AppIcons.visibility
                      : AppIcons.visibilityOff,
                    color: Get.iconColor,),
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
