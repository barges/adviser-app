import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';

class AppLoadingIndicator extends StatelessWidget {
  const AppLoadingIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Get.theme.scaffoldBackgroundColor
          .withOpacity(Get.isDarkMode ? 0.6 : 0.2),
      height: Get.height,
      width: Get.width,
      child: Center(
        child: SizedBox(
          height: 48.0,
          width: 48.0,
          child: LoadingIndicator(
            indicatorType: Indicator.lineSpinFadeLoader,
            colors: [
              Get.iconColor ?? Colors.grey,
            ],
          ),
        ),
      ),
    );
  }
}
