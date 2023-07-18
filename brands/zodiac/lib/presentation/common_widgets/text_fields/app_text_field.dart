import 'package:shared_advisor_interface/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/themes/app_colors.dart';
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
  final bool showCounter;
  final String? footerHint;

  const AppTextField({
    Key? key,
    this.focusNode,
    this.label,
    this.controller,
    this.nextFocusNode,
    this.textInputType,
    this.textInputAction,
    this.maxLength,
    this.footerHint,
    this.isPassword = false,
    this.isBig = false,
    this.errorType = ValidationErrorType.empty,
    this.hintText = '',
    this.showCounter = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

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
              style: theme.textTheme.labelMedium,
            ),
          ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
            color: errorType != ValidationErrorType.empty
                ? theme.errorColor
                : focusNode != null && focusNode!.hasPrimaryFocus
                    ? theme.primaryColor
                    : theme.hintColor,
          ),
          child: Container(
            margin: const EdgeInsets.fromLTRB(1.0, 1.0, 1.0, 2.0),
            height: (isBig ? 144.0 : AppConstants.textFieldsHeight) -
                3 +
                (showCounter ? 12.0 : 0.0),
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(AppConstants.buttonRadius - 1),
              color: theme.canvasColor,
            ),
            padding: EdgeInsets.only(bottom: showCounter ? 12.0 : 0.0),
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
                hintStyle: theme.textTheme.bodyMedium
                    ?.copyWith(color: theme.shadowColor),
                contentPadding: isBig
                    ? EdgeInsets.fromLTRB(
                        12.0, 12.0, 12.0, showCounter ? 0.0 : 12.0)
                    : const EdgeInsets.symmetric(horizontal: 12.0),

                // counterText: '',
              ),
              buildCounter: showCounter
                  ? (context,
                      {required currentLength, required isFocused, maxLength}) {
                      if (maxLength != null) {
                        final bool limitReached = currentLength >= maxLength;
                        return Text(
                          '$currentLength/$maxLength',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontSize: 14.0,
                            color: limitReached
                                ? AppColors.error
                                : AppColors.online,
                          ),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    }
                  : null,
              maxLines: isBig ? 10 : 1,
              style: theme.textTheme.bodyMedium,
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
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.errorColor,
                fontSize: 12.0,
              ),
            ),
          )
        else if (footerHint != null)
          Padding(
            padding: const EdgeInsets.only(
              top: 2.0,
              left: 12.0,
            ),
            child: Text(
              footerHint!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.shadowColor,
                fontSize: 12.0,
              ),
            ),
          )
      ],
    );
  }
}
