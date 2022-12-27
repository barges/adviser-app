import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/data/models/enums/validation_error_type.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final ValidationErrorType errorType;
  final FocusNode focusNode;
  final FocusNode? nextFocusNode;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final String hintText;
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
    this.errorType = ValidationErrorType.empty,
    this.hintText = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 12.0,
          ),
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ),
        const SizedBox(
          height: 4.0,
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
