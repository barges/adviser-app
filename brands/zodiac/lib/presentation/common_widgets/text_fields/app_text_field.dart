import 'package:shared_advisor_interface/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:zodiac/data/models/enums/validation_error_type.dart';

class AppTextField extends StatelessWidget {
  final String? label;
  final ValidationErrorType errorType;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final String hintText;
  final int? maxLength;
  final bool isPassword;
  final bool isBig;

  const AppTextField({
    Key? key,
    this.focusNode,
    this.label,
    this.controller,
    this.nextFocusNode,
    this.textInputType,
    this.textInputAction,
    this.maxLength,
    this.isPassword = false,
    this.isBig = false,
    this.errorType = ValidationErrorType.empty,
    this.hintText = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(
              left: 12.0,
              bottom: 4.0,
            ),
            child: Text(
              label!,
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
            color: errorType != ValidationErrorType.empty
                ? Theme.of(context).errorColor
                : focusNode != null && focusNode!.hasPrimaryFocus
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).hintColor,
          ),
          child: Container(
            margin: const EdgeInsets.fromLTRB(1.0, 1.0, 1.0, 2.0),
            height: (isBig ? 144.0 : AppConstants.textFieldsHeight) - 3,
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(AppConstants.buttonRadius - 1),
              color: Theme.of(context).canvasColor,
            ),
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              keyboardType: textInputType,
              maxLength: maxLength,
              textInputAction: textInputAction,
              onSubmitted: (_) {
                FocusScope.of(context).requestFocus(nextFocusNode);
              },
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Theme.of(context).shadowColor),
                contentPadding: isBig
                    ? const EdgeInsets.all(12.0)
                    : const EdgeInsets.symmetric(horizontal: 12.0),
                counterText: '',
              ),
              maxLines: isBig ? 10 : 1,
              style: Theme.of(context).textTheme.bodyMedium,
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
