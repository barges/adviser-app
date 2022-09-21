import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/appbar/simple_app_bar.dart';
import 'package:shared_advisor_interface/presentation/resources/app_routes.dart';

class AccountScreen extends GetView {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleAppBar(
        title: 'Account',
      ),
      body: SizedBox(
        height: Get.height,
        child: Center(
          child: GestureDetector(
              onTap: (){
                Get.toNamed(AppRoutes.editProfile);
              },
              child: const Text('Account')),
        ),
      ),
    );
  }
}
