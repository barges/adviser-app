import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppIconGradientButton extends StatelessWidget {
  final String icon;
  final Color? iconColor;
  final VoidCallback? onTap;

  const AppIconGradientButton({
    Key? key,
    required this.icon,
    this.iconColor,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: AppConstants.iconButtonSize,
        width: AppConstants.iconButtonSize,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [AppColors.ctaGradient1, AppColors.ctaGradient2]),
          borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
        ),
        child: Center(
          child: SvgPicture.asset(
            icon,
            color: iconColor,
            width: AppConstants.iconSize,
            height: AppConstants.iconSize,
          ),
        ),
      ),
    );
  }
}
