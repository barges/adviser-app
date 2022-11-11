import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';

class EmptyListWidget extends StatelessWidget {
  final String title;
  final String? label;

  const EmptyListWidget({
    Key? key,
    required this.title,
    this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Get.isDarkMode
            ? Assets.images.logos.emptyListLogoDark.image(
                height: AppConstants.logoSize,
                width: AppConstants.logoSize,
              )
            : Assets.images.logos.emptyListLogo.image(
                height: AppConstants.logoSize,
                width: AppConstants.logoSize,
              ),
        const SizedBox(
          height: 24.0,
        ),
        Text(
          title,
          style: Get.textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),
        if (label != null)
          Column(
            children: [
              const SizedBox(
                height: 8.0,
              ),
              Text(
                label!,
                style: Get.textTheme.bodyMedium?.copyWith(
                  fontSize: 16.0,
                  color: Get.theme.shadowColor,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
      ],
    );
  }
}
