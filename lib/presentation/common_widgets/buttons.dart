import 'package:flutter/material.dart';

class AppElevatedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? text;

  const AppElevatedButton({Key? key, this.onPressed, this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                const EdgeInsets.symmetric(vertical: 14.0)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ))),
        child: Text(text ?? ''),
      ),
    );
  }
}
