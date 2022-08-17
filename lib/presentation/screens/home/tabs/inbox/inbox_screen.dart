import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/appbar/simple_app_bar.dart';
import 'package:shared_advisor_interface/presentation/resources/app_routes.dart';

class InboxScreen extends GetView {
  const InboxScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleAppBar(
        title: 'Inbox',
      ),
      body: SizedBox(
        height: Get.height,
        child: GestureDetector(
          onTap: () {
            Get.toNamed(AppRoutes.notifications);
          },
          child: const Center(
            child: Text('Inbox'),
          ),
        ),
      ),
    );
  }
}
