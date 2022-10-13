import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/data/cache/cache_manager.dart';
import 'package:shared_advisor_interface/data/models/user_info/fortunica_user_status.dart';
import 'package:shared_advisor_interface/data/models/user_info/user_status.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/appbar/wide_app_bar.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/messages/app_error_widget.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
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
        return Scaffold(
          appBar: const WideAppBar(),
          body: Builder(builder: (context) {
            final UserStatus currentStatus =
                context.select((HomeCubit cubit) => cubit.state.userStatus);
            final String? statusErrorText = currentStatus.status?.errorText();
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
                              horizontal: AppConstants.horizontalScreenPadding,
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
        );
      }),
    );
  }
}
