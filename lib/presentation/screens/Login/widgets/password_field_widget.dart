import 'package:flutter/material.dart';

class PasswordFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final TextInputAction? textInputAction;
  final TextInputType? textInputType;
  final bool showErrorText;
  final String? errorText;

  final String? label;

  const PasswordFieldWidget(
      {Key? key,
      required this.controller,
      this.textInputAction,
      this.textInputType,
      this.label,
      this.showErrorText = false,
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
                style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
        Ink(
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child: ValueListenableBuilder<bool>(
              valueListenable: hiddenPassword,
              builder: (_, isHidden, __) {
                return TextField(obscureText: isHidden,
                    controller: controller,
                    keyboardType: TextInputType.text,
                    textInputAction: textInputAction,
                    showCursor: false,
                    maxLines: 1,
                    decoration: InputDecoration(
                        suffixIcon: GestureDetector(
                            onTap: () {
                              hiddenPassword.value=!hiddenPassword.value;
                            },
                            child: Icon(isHidden
                                ? Icons.visibility_off
                                : Icons.visibility)),
                        border: const OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1, color: Color(0xffEADDEA)))));
              }),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(showErrorText && errorText != null ? errorText! : '',
              style: const TextStyle(
                  color: Colors.red,
                  fontSize: 13.0,
                  fontWeight: FontWeight.w400)),
        )
      ],
    );
  }
}
