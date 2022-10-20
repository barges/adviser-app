import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';

class EmptyListWidget extends StatelessWidget {
  final String title;

  const EmptyListWidget({Key? key, required this.title}) : super(key: key);

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
      ],
    );
  }
}
