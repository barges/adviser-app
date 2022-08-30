import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/appbar/simple_app_bar.dart';

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
        child: const Center(
          child: Text('Account'),
        ),
      ),
    );
  }
}
