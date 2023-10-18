import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';

import '../../../app_constants.dart';
import '../../../themes/app_colors.dart';

class AppElevatedButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final String? iconPath;
  final Color? color;

  const AppElevatedButton({
    Key? key,
    required this.title,
    required this.onPressed,
    this.iconPath,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: onPressed != null ? 1.0 : 0.4,
      child: Container(
        width: double.infinity,
        height: 48.0,
        decoration: BoxDecoration(
          color: color,
          gradient: color == null
              ? const LinearGradient(
                  colors: [AppColors.ctaGradient1, AppColors.ctaGradient2])
              : null,
          borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
        ),
        child: ElevatedButton(
          onPressed: onPressed ?? () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  AppConstants.buttonRadius,
                ),
              ),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (iconPath != null)
                Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: SvgPicture.asset(
                    iconPath!,
                    height: AppConstants.iconSize,
                    width: AppConstants.iconSize,
                    color: Theme.of(context)
                        .elevatedButtonTheme
                        .style
                        ?.textStyle
                        ?.resolve({})?.color,
                  ),
                ),
              Text(
                title,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
