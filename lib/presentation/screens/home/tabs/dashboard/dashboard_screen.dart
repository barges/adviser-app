import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/appbar/home_app_bar.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/choose_option_widget.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/dashboard/dashboard_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/dashboard/pages/courses_page.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/dashboard/pages/resources_page/resourses_page.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/dashboard/pages/stats_page.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DashboardCubit(),
      child: Builder(builder: (context) {
        final DashboardCubit dashboardCubit = context.read<DashboardCubit>();
        return Scaffold(
            appBar: HomeAppBar(
              withBrands: true,
              title: S.of(context).dashboard,
              iconPath: Assets.vectors.items.path,
              bottomWidget: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.horizontalScreenPadding),
                child: Builder(builder: (context) {
                  final int dashboardPageViewIndex = context.select(
                      (DashboardCubit cubit) =>
                          cubit.state.dashboardPageViewIndex);
                  return ChooseOptionWidget(
                    options: [
                      S.of(context).resources,
                      S.of(context).stats,
                      S.of(context).courses
                    ],
                    currentIndex: dashboardPageViewIndex,
                    onChangeOptionIndex:
                        dashboardCubit.updateDashboardPageViewIndex,
                  );
                }),
              ),
            ),
            body: PageView(
              controller: dashboardCubit.pageController,
              onPageChanged: dashboardCubit.updateDashboardPageViewIndex,
              children: const [ResourcesPage(), StatsView(), CoursesPage()],
            ));
      }),
    );
  }
}
