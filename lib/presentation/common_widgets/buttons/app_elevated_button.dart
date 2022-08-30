import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/themes/app_colors.dart';

class AppElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const AppElevatedButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 42.0,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: [AppColors.ctaGradient1, AppColors.ctaGradient2]),
        borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          primary: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: const RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.all(Radius.circular(AppConstants.buttonRadius))),
        ),
        child: Text(text),
      ),
    );
  }
}
