import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/appbar/simple_app_bar.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/dashboard/dashboard_controller.dart';
import 'package:shared_advisor_interface/presentation/screens/login/login_cubit.dart';

class DashboardScreen extends GetView<DashboardController> {
  final VoidCallback? openDrawer;

  const DashboardScreen({Key? key, required this.openDrawer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(
        title: 'Dashboard',
        openDrawer: openDrawer,
      ),
      body: SizedBox(
        height: Get.height,
        child: GestureDetector(
          onTap: () {
            logger.d(context.read<LoginCubit>);
          },
          child: Center(
            child: Obx(
              () {
                return Text(controller.currentBrand.value?.name ?? 'NULL');
              },
            ),
          ),
        ),
      ),
    );
  }
}
