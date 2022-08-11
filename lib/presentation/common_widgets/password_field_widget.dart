import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/presentation/themes/app_colors_light.dart';

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
                style: Theme.of(context).textTheme.titleMedium),
          ),
        Ink(
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: AppColorsLight.uinegative,
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
                    style: Theme.of(context).textTheme.bodyMedium,
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
                                width: 1, color: AppColorsLight.highlight))));
              }),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(showErrorText && errorText != null ? errorText! : '',
              style: Theme.of(context).textTheme.bodySmall),
        )
      ],
    );
  }
}
