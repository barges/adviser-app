import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/presentation/resources/app_colors.dart';
import 'package:shared_advisor_interface/presentation/resources/app_text_styles.dart';

class PasswordFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final TextInputAction? textInputAction;
  final bool showErrorText;
  final String? errorText;
  final ValueChanged<String>? onSubmitted;
  final FocusNode? focusNode;
  final String? label;

  const PasswordFieldWidget(
      {Key? key,
      required this.controller,
      this.textInputAction,
      this.label,
      this.showErrorText = false,
      this.onSubmitted,
      this.focusNode,
      this.errorText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> hiddenPassword = ValueNotifier(false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Text(label ?? '',
                style: AppTextStyles.titleMedium),
          ),
        Ink(
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Theme.of(context).canvasColor,
          ),
          child: ValueListenableBuilder<bool>(
              valueListenable: hiddenPassword,
              builder: (_, isHidden, __) {
                return TextField(
                    focusNode: focusNode,
                    obscureText: isHidden,
                    controller: controller,
                    keyboardType: TextInputType.text,
                    textInputAction: textInputAction,
                    onSubmitted: onSubmitted,
                    style: AppTextStyles.bodyMedium,
                    showCursor: false,
                    maxLines: 1,
                    decoration: InputDecoration(
                        suffixIcon: GestureDetector(
                            onTap: () {
                              hiddenPassword.value = !hiddenPassword.value;
                            },
                            child: Icon(isHidden
                                ? Icons.visibility_off
                                : Icons.visibility)),
                        border: const OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1, color: AppColors.highlight))));
              }),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(showErrorText && errorText != null ? errorText! : '',
              style: AppTextStyles.errorTextStyle),
        )
      ],
    );
  }
}
