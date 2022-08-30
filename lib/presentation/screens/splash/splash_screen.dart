import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/presentation/resources/app_images.dart';
import 'package:shared_advisor_interface/presentation/screens/splash/splash_controller.dart';

class SplashScreen extends GetView<SplashController> {
 const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: Get.height,
        width: Get.width,
        child: Image.asset(
          AppImages.splash,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
