import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/infrastructure/di/brand_manager.dart';
import 'package:shared_advisor_interface/services/check_permission_service.dart';
import 'package:shared_advisor_interface/services/connectivity_service.dart';
import 'package:shared_advisor_interface/services/push_notification/push_notification_manager.dart';
import 'package:zodiac/data/cache/zodiac_caching_manager.dart';
import 'package:zodiac/domain/repositories/zodiac_user_repository.dart';
import 'package:zodiac/infrastructure/di/inject_config.dart';
import 'package:zodiac/presentation/common_widgets/appbar/home_app_bar.dart';
import 'package:zodiac/presentation/common_widgets/messages/app_error_widget.dart';
import 'package:zodiac/presentation/screens/home/tabs/account/widgets/reviews_part_widget.dart';
import 'package:zodiac/presentation/screens/home/tabs/account/widgets/user_fee_part_widget.dart';
import 'package:zodiac/presentation/screens/home/tabs/account/widgets/user_info_part_widget.dart';
import 'package:zodiac/presentation/screens/home/tabs/account/zodiac_account_cubit.dart';
import 'package:zodiac/zodiac_main_cubit.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ZodiacAccountCubit(
        zodiacGetIt.get<BrandManager>(),
        zodiacGetIt.get<ZodiacMainCubit>(),
        zodiacGetIt.get<ZodiacUserRepository>(),
        zodiacGetIt.get<ZodiacCachingManager>(),
        zodiacGetIt.get<ConnectivityService>(),
        zodiacGetIt.get<PushNotificationManager>(),
        (value) => handlePermission(context, value),
      ),
      child: Scaffold(
          appBar: const HomeAppBar(),
          body: Builder(builder: (context) {
            ZodiacAccountCubit accountCubit =
                context.read<ZodiacAccountCubit>();
            return SafeArea(
              child: RefreshIndicator(
                onRefresh: accountCubit.refreshUserInfo,
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          Builder(builder: (context) {
                            final ZodiacAccountCubit zodiacAccountCubit =
                                context.read<ZodiacAccountCubit>();
                            final String errorMessage = context.select(
                                (ZodiacAccountCubit cubit) =>
                                    cubit.state.errorMessage);
                            return AppErrorWidget(
                              errorMessage: errorMessage,
                              close: zodiacAccountCubit.clearErrorMessage,
                            );
                          }),
                          Padding(
                            padding: const EdgeInsets.all(
                                AppConstants.horizontalScreenPadding),
                            child: Column(
                              children: const [
                                UserInfoPartWidget(),
                                SizedBox(
                                  height: 24.0,
                                ),
                                UserFeePartWidget(),
                                SizedBox(
                                  height: 24.0,
                                ),
                                ReviewsPartWidget(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          })),
    );
  }

  Future<bool> handlePermission(
      BuildContext context, bool needShowSettingsAlert) async {
    return await zodiacGetIt.get<CheckPermissionService>().handlePermission(
        context, PermissionType.notification,
        needShowSettings: needShowSettingsAlert);
  }
}
