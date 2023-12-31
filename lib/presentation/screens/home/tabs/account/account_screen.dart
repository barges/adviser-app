import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/data/cache/caching_manager.dart';
import 'package:shared_advisor_interface/data/models/app_errors/app_error.dart';
import 'package:shared_advisor_interface/data/models/user_info/user_status.dart';
import 'package:shared_advisor_interface/domain/repositories/user_repository.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/main_state.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/appbar/home_app_bar.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/messages/app_error_widget.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/no_connection_widget.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/screens/home/home_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/account/account_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/account/widgets/reviews_settings_part_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/account/widgets/user_info_part_widget.dart';
import 'package:shared_advisor_interface/presentation/services/check_permission_service.dart';
import 'package:shared_advisor_interface/presentation/services/connectivity_service.dart';
import 'package:shared_advisor_interface/presentation/services/push_notification/push_notification_manager.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MainCubit mainCubit = context.read<MainCubit>();
    return BlocProvider(
      create: (_) => AccountCubit(
        getIt.get<CachingManager>(),
        mainCubit,
        getIt.get<UserRepository>(),
        getIt.get<PushNotificationManager>(),
        getIt.get<ConnectivityService>(),
        (value) => handlePermission(context, value),
      ),
      child: Builder(builder: (context) {
        final AccountCubit accountCubit = context.read<AccountCubit>();
        return BlocListener<MainCubit, MainState>(
          listenWhen: (prev, current) =>
              prev.internetConnectionIsAvailable !=
              current.internetConnectionIsAvailable,
          listener: (_, state) {
            if (state.internetConnectionIsAvailable) {
              accountCubit.firstGetUserInfo();
            }
          },
          child: Scaffold(
            appBar: const HomeAppBar(),
            body: Builder(builder: (context) {
              final bool isOnline = context.select((MainCubit cubit) =>
                  cubit.state.internetConnectionIsAvailable);

              final UserStatus? currentStatus =
                  context.select((HomeCubit cubit) => cubit.state.userStatus);
              final String? statusErrorText =
                  currentStatus?.status?.errorText(context);
              final AppError appError =
                  context.select((MainCubit cubit) => cubit.state.appError);

              if (isOnline) {
                return Column(
                  children: [
                    AppErrorWidget(
                      errorMessage: statusErrorText ?? '',
                      isRequired: true,
                    ),
                    if (statusErrorText == null ||
                        statusErrorText.isEmpty == true)
                      AppErrorWidget(
                        errorMessage: appError.getMessage(context),
                        close: accountCubit.closeErrorWidget,
                      ),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: accountCubit.refreshUserinfo,
                        child: CustomScrollView(
                          slivers: [
                            SliverToBoxAdapter(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal:
                                      AppConstants.horizontalScreenPadding,
                                ),
                                child: Column(
                                  children: const [
                                    SizedBox(
                                      height: 24.0,
                                    ),
                                    UserInfoPartWidget(),
                                    SizedBox(
                                      height: 24.0,
                                    ),
                                    ReviewsSettingsPartWidget(),
                                  ],
                                ),
                              ),
                            ),
                            // const SliverFillRemaining(
                            //   hasScrollBody: false,
                            //   fillOverscroll: false,
                            //   child: SeeMoreWidget(),
                            // )
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return CustomScrollView(
                  physics: const ClampingScrollPhysics(),
                  slivers: [
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          NoConnectionWidget(),
                        ],
                      ),
                    ),
                  ],
                );
              }
            }),
          ),
        );
      }),
    );
  }

  Future<bool> handlePermission(
      BuildContext context, bool needShowSettingsAlert) async {
    return await getIt.get<CheckPermissionService>().handlePermission(
        context, PermissionType.notification,
        needShowSettings: needShowSettingsAlert);
  }
}
