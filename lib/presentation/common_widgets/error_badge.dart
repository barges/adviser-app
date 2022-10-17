import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ErrorBadge extends StatelessWidget {
  const ErrorBadge({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 12.0,
      width: 12.0,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Get.theme.errorColor,
          border: Border.all(
            width: 2.0,
            color: Get.theme.scaffoldBackgroundColor,
          )),
    );
  }
}
