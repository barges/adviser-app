import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/presentation/resources/app_colors.dart';
import 'package:shared_advisor_interface/presentation/themes/app_colors_light.dart';

class AppTextStyles {
  final bool isDark = Get.isDarkMode;

  static const TextStyle appBarTitleStyle = TextStyle(
      color: AppColors.darkBlue, fontSize: 17.0, fontWeight: FontWeight.w400);
  static const TextStyle labelMedium = TextStyle(color: AppColors.secondary);
  static const TextStyle titleMedium =
      TextStyle(fontWeight: FontWeight.w500, color: AppColors.darkBlue);
  static const TextStyle bodyMedium = TextStyle(
      fontWeight: FontWeight.w400, fontSize: 15.0, color: AppColors.darkBlue);
  static const TextStyle errorTextStyle = TextStyle(
      color: AppColorsLight.error, fontSize: 13.0, fontWeight: FontWeight.w400);
  static const TextStyle buttonTextStyle = TextStyle(
      color: Colors.white, fontSize: 17.0, fontWeight: FontWeight.w600);
}
