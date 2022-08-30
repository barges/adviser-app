import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/appbar/simple_app_bar.dart';
import 'package:shared_advisor_interface/presentation/resources/app_routes.dart';

class DashboardScreen extends GetView {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleAppBar(
        title: 'Dashboard',
      ),
      body: SizedBox(
        height: Get.height,
        child: GestureDetector(
          onTap: () {
            Get.toNamed(AppRoutes.allBrands);
          },
          child: const Center(
            child: Text('Dashboard'),
          ),
        ),
      ),
    );
  }
}
