import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/themes/app_colors.dart';

class AppGradientButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool isActive;

  const AppGradientButton({
    Key? key,
    required this.title,
    required this.onTap,
    this.isActive = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isActive ? onTap : null,
      child: Opacity(
        opacity: isActive ? 1.0 : 0.4,
        child: Container(
          alignment: Alignment.center,
          height: 48.0,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
            gradient: const LinearGradient(
              colors: [
                AppColors.ctaGradient1,
                AppColors.ctaGradient2,
              ],
            ),
          ),
          child: Text(
            title,
            style: Get.textTheme.titleMedium?.copyWith(
              color: Get.theme.backgroundColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
