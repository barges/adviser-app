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
  final String detailsText;
  final bool isPassword;
  final bool isBig;
  final bool isEnabled;

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
    this.detailsText = '',
    this.isEnabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isNotEmptyError = errorType != ValidationErrorType.empty;

    final BorderRadius outerRadius =
        BorderRadius.circular(AppConstants.buttonRadius);
    final BorderRadius innerRadius =
        BorderRadius.circular(AppConstants.buttonRadius - 1);
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
            borderRadius: outerRadius,
            color: isNotEmptyError
                ? Theme.of(context).errorColor
                : focusNode.hasPrimaryFocus
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).hintColor,
          ),
          child: Container(
            margin: const EdgeInsets.fromLTRB(1.0, 1.0, 1.0, 2.0),
            height: (isBig ? 144.0 : AppConstants.textFieldsHeight) - 3,
            decoration: BoxDecoration(
              borderRadius: innerRadius,
              color: Theme.of(context).canvasColor,
            ),
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              keyboardType: textInputType,
              textInputAction: textInputAction,
              textCapitalization: isBig
                  ? TextCapitalization.sentences
                  : TextCapitalization.none,
              onSubmitted: (_) {
                FocusScope.of(context).requestFocus(nextFocusNode);
              },
              decoration: InputDecoration(
                enabled: isEnabled,
                hintText: hintText,
                hintStyle: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Theme.of(context).shadowColor),
                contentPadding: isBig
                    ? const EdgeInsets.all(12.0)
                    : const EdgeInsets.symmetric(horizontal: 12.0),
                disabledBorder: OutlineInputBorder(
                    borderRadius: innerRadius,
                    borderSide: BorderSide(color: Theme.of(context).hintColor)),
                filled: !isEnabled,
                fillColor: Theme.of(context).scaffoldBackgroundColor,
              ),
              maxLines: isBig ? 10 : 1,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isEnabled
                      ? Theme.of(context).hoverColor
                      : Theme.of(context).shadowColor),
            ),
          ),
        ),
        if (isNotEmptyError || !isEnabled)
          Padding(
            padding: const EdgeInsets.only(
              top: 2.0,
              left: 12.0,
            ),
            child: Text(
              isEnabled ? errorType.text(context) : detailsText,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isEnabled
                        ? Theme.of(context).errorColor
                        : Theme.of(context).shadowColor,
                    fontSize: 12.0,
                  ),
            ),
          )
      ],
    );
  }
}
