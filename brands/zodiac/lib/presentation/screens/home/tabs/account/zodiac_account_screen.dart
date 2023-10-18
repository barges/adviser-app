import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/data/models/app_error/app_error.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/services/check_permission_service.dart';
import 'package:zodiac/data/models/app_success/app_success.dart';
import 'package:zodiac/infrastructure/di/inject_config.dart';
import 'package:zodiac/presentation/common_widgets/appbar/home_app_bar.dart';
import 'package:zodiac/presentation/common_widgets/messages/app_error_widget.dart';
import 'package:zodiac/presentation/common_widgets/messages/app_success_widget.dart';
import 'package:zodiac/presentation/common_widgets/no_connection_widget.dart';
import 'package:zodiac/presentation/screens/home/tabs/account/widgets/daily_coupons/daily_coupons_part_widget.dart';
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
      create: (_) => zodiacGetIt.get<ZodiacAccountCubit>(
          param1: (value) => handlePermission(context, value)),
      child: Scaffold(
          appBar: const HomeAppBar(),
          body: Builder(builder: (context) {
            ZodiacAccountCubit accountCubit =
                context.read<ZodiacAccountCubit>();
            return Builder(builder: (context) {
              final bool internetConnectionIsAvailable = context.select(
                  (MainCubit cubit) =>
                      cubit.state.internetConnectionIsAvailable);
              if (internetConnectionIsAvailable) {
                return Stack(
                  children: [
                    SafeArea(
                      child: RefreshIndicator(
                        onRefresh: accountCubit.refreshUserInfo,
                        child: CustomScrollView(
                          slivers: [
                            SliverToBoxAdapter(
                              child: Column(
                                children: [
                                  Builder(builder: (context) {
                                    final ZodiacAccountCubit
                                        zodiacAccountCubit =
                                        context.read<ZodiacAccountCubit>();
                                    final String errorMessage = context.select(
                                        (ZodiacAccountCubit cubit) =>
                                            cubit.state.errorMessage);
                                    return AppErrorWidget(
                                      errorMessage: errorMessage,
                                      close:
                                          zodiacAccountCubit.clearErrorMessage,
                                    );
                                  }),
                                  const Padding(
                                    padding: EdgeInsets.all(
                                        AppConstants.horizontalScreenPadding),
                                    child: Column(
                                      children: [
                                        UserInfoPartWidget(),
                                        SizedBox(
                                          height: 24.0,
                                        ),
                                        UserFeePartWidget(),
                                        SizedBox(
                                          height: 24.0,
                                        ),
                                        ReviewsPartWidget(),
                                        SizedBox(
                                          height: 24.0,
                                        ),
                                        DailyCouponsPartWidget(),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                        top: 0.0,
                        right: 0.0,
                        left: 0.0,
                        child: Builder(builder: (context) {
                          final AppSuccess appSuccess = context.select(
                              (ZodiacAccountCubit cubit) =>
                                  cubit.state.appSuccess);
                          return AppSuccessWidget(
                            title: appSuccess.getTitle(context),
                            message: appSuccess.getMessage(context),
                            onClose: accountCubit.clearSuccessMessage,
                          );
                        })),
                    Positioned(
                        top: 0.0,
                        right: 0.0,
                        left: 0.0,
                        child: Builder(builder: (context) {
                          final AppError appError = context.select(
                              (ZodiacMainCubit cubit) => cubit.state.appError);
                          return AppErrorWidget(
                            errorMessage: appError.getMessage(context),
                            close: context
                                .read<ZodiacMainCubit>()
                                .clearErrorMessage,
                          );
                        }))
                  ],
                );
              } else {
                return const CustomScrollView(
                  slivers: [
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          NoConnectionWidget(),
                        ],
                      ),
                    )
                  ],
                );
              }
            });
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
