import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zodiac/data/models/enums/validation_error_type.dart';

class PasswordTextField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputAction? textInputAction;
  final bool hiddenPassword;
  final ValidationErrorType errorType;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? clickToHide;
  final FocusNode focusNode;
  final String? label;
  final String hintText;

  const PasswordTextField({
    Key? key,
    required this.controller,
    required this.focusNode,
    required this.hintText,
    this.textInputAction,
    this.label,
    this.onSubmitted,
    this.clickToHide,
    this.errorType = ValidationErrorType.empty,
    this.hiddenPassword = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(
              bottom: 4.0,
              left: 12.0,
            ),
            child: Text(label ?? '',
                style: Theme.of(context).textTheme.labelMedium),
          ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
            color: errorType != ValidationErrorType.empty
                ? Theme.of(context).errorColor
                : focusNode.hasPrimaryFocus
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).hintColor,
          ),
          child: Container(
            margin: const EdgeInsets.fromLTRB(1.0, 1.0, 1.0, 2.0),
            height: AppConstants.textFieldsHeight - 3,
            decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
            ),
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              obscureText: hiddenPassword,
              obscuringCharacter: '*',
              keyboardType: TextInputType.visiblePassword,
              textInputAction: textInputAction,
              onSubmitted: onSubmitted,
              inputFormatters: [
                FilteringTextInputFormatter.deny(RegExp(r'\s')),
              ],
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 1,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Theme.of(context).shadowColor),
                suffixIconConstraints: const BoxConstraints(
                  minWidth: AppConstants.iconSize,
                ),
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: GestureDetector(
                    onTap: clickToHide,
                    child: hiddenPassword
                        ? Assets.vectors.visibilityOff.svg(
                            color: Theme.of(context).iconTheme.color,
                          )
                        : Assets.vectors.visibility.svg(
                            color: Theme.of(context).iconTheme.color,
                          ),
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
              ),
            ),
          ),
        ),
        if (errorType != ValidationErrorType.empty)
          Padding(
            padding: const EdgeInsets.only(
              top: 2.0,
              left: 12.0,
            ),
            child: Text(
              errorType.text(context),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).errorColor,
                    fontSize: 12.0,
                  ),
            ),
          )
      ],
    );
  }
}
