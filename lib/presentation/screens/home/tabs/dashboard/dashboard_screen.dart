import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/configuration.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/main_cibit.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/appbar/simple_app_bar.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/dashboard/dashboard_cubit.dart';

class DashboardScreen extends StatelessWidget {
  final VoidCallback? openDrawer;

  const DashboardScreen({Key? key, required this.openDrawer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DashboardCubit(),
      child: Scaffold(
        appBar: SimpleAppBar(
          title: 'Dashboard',
          openDrawer: openDrawer,
        ),
        body: SizedBox(
          height: Get.height,
          child: GestureDetector(
            onTap: () {
              logger.d(context.read<MainCubit>);
            },
            child: Center(
              child: Builder(
                builder: (context) {
                  final Brand currentBrand = context
                      .select((MainCubit cubit) => cubit.state.currentBrand);
                  return Text(currentBrand.name);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
