import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/data/cache/caching_manager.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/appbar/home_app_bar.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/dashboard_v1/dashboard_v1_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/dashboard_v1/widgets/month_statistic_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/dashboard_v1/widgets/personal_information_widget.dart';

class DashboardV1Screen extends StatelessWidget {
  const DashboardV1Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => DashboardV1Cubit(Get.find<CachingManager>()),
        child: Builder(builder: (context) {
          final DashboardV1Cubit dashboardCubit =
              context.read<DashboardV1Cubit>();
          final bool isOnline = context.select(
              (MainCubit cubit) => cubit.state.internetConnectionIsAvailable);
          return Scaffold(
              appBar: HomeAppBar(
                  withBrands: true,
                  title: S.of(context).dashboard,
                  iconPath: Assets.vectors.items.path),
              body: SingleChildScrollView(
                padding: EdgeInsets.all(AppConstants.horizontalScreenPadding),
                child: Column(
                  children: const [
                    PersonalInformationWidget(),
                    SizedBox(
                      height: AppConstants.horizontalScreenPadding,
                    ),
                    MonthStatisticWidget()
                  ],
                ),
              ));
        }));
  }
}
