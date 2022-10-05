import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/configuration.dart';
import 'package:shared_advisor_interface/data/cache/cache_manager.dart';
import 'package:shared_advisor_interface/data/models/enums/fortunica_user_status.dart';
import 'package:shared_advisor_interface/data/models/user_info/user_status.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/app_loading_indicator.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/change_locale_button.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/messages/app_error_widget.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/screens/drawer/app_drawer.dart';
import 'package:shared_advisor_interface/presentation/screens/home/home_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/account/account_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/account/widgets/reviews_settings_part_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/account/widgets/see_more_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/account/widgets/user_info_part_widget.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AccountCubit(Get.find<CacheManager>()),
      child: Builder(builder: (context) {
        final AccountCubit accountCubit = context.read<AccountCubit>();
        final HomeCubit homeCubit = context.read<HomeCubit>();

        return Stack(
          children: [
            Scaffold(
              key: accountCubit.scaffoldKey,
              drawer: const AppDrawer(),
              appBar: AppBar(
                  automaticallyImplyLeading: false,
                  toolbarHeight: 84.0,
                  flexibleSpace: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 32.0,
                          left: AppConstants.horizontalScreenPadding,
                          right: AppConstants.horizontalScreenPadding),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Builder(builder: (context) {
                            final Brand currentBrand = context.select(
                                (MainCubit cubit) => cubit.state.currentBrand);
                            return GestureDetector(
                              onTap: homeCubit.openDrawer,
                              child: Row(
                                children: [
                                  Container(
                                    height: 32.0,
                                    width: 32.0,
                                    padding: const EdgeInsets.all(4.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          AppConstants.buttonRadius),
                                      color: Get.theme.scaffoldBackgroundColor,
                                    ),
                                    child: SvgPicture.asset(currentBrand.icon),
                                  ),
                                  const SizedBox(width: 8.0),
                                  Text(currentBrand.name,
                                      style: Get.textTheme.headlineMedium)
                                ],
                              ),
                            );
                          }),
                          const ChangeLocaleButton()
                        ],
                      ),
                    ),
                  )),
              body: Builder(builder: (context) {
                final UserStatus currentStatus =
                    context.select((HomeCubit cubit) => cubit.state.userStatus);
                final String? statusErrorText =
                    currentStatus.status?.errorText(context);
                return Column(
                  children: [
                    statusErrorText?.isNotEmpty == true
                        ? AppErrorWidget(
                            errorMessage: statusErrorText ?? '',
                            isRequired: true,
                          )
                        : const SizedBox.shrink(),
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
                            const SliverFillRemaining(
                              hasScrollBody: false,
                              fillOverscroll: false,
                              child: SeeMoreWidget(),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
            Builder(
              builder: (context) {
                final bool isLoading = context
                    .select((AccountCubit cubit) => cubit.state.isLoading);
                return AppLoadingIndicator(
                  showIndicator: isLoading,
                );
              },
            ),
          ],
        );
      }),
    );
  }
}
