import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';

class PasswordTextField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputAction? textInputAction;
  final bool hiddenPassword;
  final String errorText;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? clickToHide;
  final FocusNode focusNode;
  final String? label;

  const PasswordTextField({
    Key? key,
    required this.controller,
    required this.focusNode,
    this.textInputAction,
    this.label,
    this.onSubmitted,
    this.clickToHide,
    this.errorText = '',
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
            color: errorText.isNotEmpty
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
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 1,
              decoration: InputDecoration(
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
        if (errorText.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(
              top: 2.0,
              left: 12.0,
            ),
            child: Text(
              errorText,
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
