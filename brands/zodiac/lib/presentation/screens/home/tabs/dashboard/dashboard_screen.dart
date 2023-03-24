import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:zodiac/data/cache/zodiac_caching_manager.dart';
import 'package:zodiac/domain/repositories/zodiac_user_repository.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/infrastructure/di/inject_config.dart';
import 'package:zodiac/presentation/common_widgets/appbar/home_app_bar.dart';
import 'package:zodiac/presentation/screens/home/tabs/dashboard/dashboard_cubit.dart';
import 'package:zodiac/presentation/screens/home/tabs/dashboard/widgets/month_statistic_widget.dart';
import 'package:zodiac/presentation/screens/home/tabs/dashboard/widgets/user_info_part_widget.dart';
import 'package:zodiac/zodiac_main_cubit.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DashboardCubit(
        zodiacGetIt.get<ZodiacCachingManager>(),
        zodiacGetIt.get<ZodiacMainCubit>(),
        zodiacGetIt.get<ZodiacUserRepository>(),
      ),
      child: Scaffold(
        appBar: HomeAppBar(
          title: SZodiac.of(context).dashboardZodiac,
          withBrands: true,
          iconPath: Assets.vectors.items.path,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Padding(
              padding:
                  const EdgeInsets.all(AppConstants.horizontalScreenPadding),
              child: Column(
                children: const [
                  DashboardUserInfoPartWidget(),
                  SizedBox(
                    height: 16.0,
                  ),
                  MonthStatisticWidget()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
