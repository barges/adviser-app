import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/data/cache/caching_manager.dart';
import 'package:shared_advisor_interface/data/models/user_info/fortunica_user_status.dart';
import 'package:shared_advisor_interface/data/models/user_info/user_status.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/appbar/wide_app_bar.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/appbar/home_app_bar.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_elevated_button.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_icon_button.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/choose_option_widget.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/list_of_filters_widget.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/no_connection_widget.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/screens/home/home_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/sessions/sessions_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/sessions/sessions_state.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/sessions/widgets/list_of_questions_widget.dart';

class SessionsScreen extends StatelessWidget {
  const SessionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SessionsCubit(Get.find<CachingManager>()),
      child: Builder(builder: (BuildContext context) {
        final bool isOnline = context.select(
            (MainCubit cubit) => cubit.state.internetConnectionIsAvailable);

        final UserStatus userStatus =
            context.select((HomeCubit cubit) => cubit.state.userStatus);
        final SessionsCubit sessionsCubit = context.read<SessionsCubit>();

        final bool statusIsLive =
            userStatus.status == FortunicaUserStatusEnum.live;

        return Scaffold(
          backgroundColor: isOnline
              ? Get.theme.canvasColor
              : Get.theme.scaffoldBackgroundColor,
          appBar: HomeAppBar(
            bottomWidget: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.horizontalScreenPadding,
              ),
              child: Opacity(
                opacity: isOnline && statusIsLive ? 1.0 : 0.4,
                child: Row(
                  children: [
                    Expanded(
                      child: Builder(builder: (context) {
                        final int currentIndex = context.select(
                            (SessionsCubit cubit) =>
                                cubit.state.currentOptionIndex);
                        return ChooseOptionWidget(
                          options: [
                            S.of(context).public,
                            S.of(context).forMe,
                          ],
                          currentIndex: currentIndex,
                          onChangeOptionIndex: isOnline && statusIsLive
                              ? sessionsCubit.getListOfQuestions
                              : null,
                        );
                      }),
                    ),
                    const SizedBox(width: 8.0),
                    AppIconButton(
                      icon: Assets.vectors.search.path,
                      onTap: statusIsLive ? () {} : null,
                    ),
                  ],
                ),
              ),
            ),
            withBrands: true,
          ),
          body: Builder(builder: (context) {
            if (isOnline) {
              if (statusIsLive) {
                return const _QuestionsListWidget();
              } else {
                return _NotLiveStatusWidget(
                  status: userStatus.status ?? FortunicaUserStatusEnum.offline,
                );
              }
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  NoConnectionWidget(),
                ],
              );
            }
          }),
        );
      }),
    );
  }
}

class _QuestionsListWidget extends StatelessWidget {
  const _QuestionsListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SessionsCubit sessionsCubit = context.read<SessionsCubit>();
    return SingleChildScrollView(
      controller: sessionsCubit.controller,
      child: Builder(builder: (context) {
        final List<String> filters = [
          'All',
          'Only Premium Products',
          'Private Questions',
          'Market: '
        ];
        return Column(children: [
          Column(
            children: [
              Container(
                height: AppConstants.appBarHeight,
                color: Get.theme.canvasColor,
                child: Builder(builder: (context) {
                  final int selectedFilterIndex = context.select(
                      (SessionsCubit cubit) => cubit.state.selectedFilterIndex);
                  return ListOfFiltersWidget(
                    currentFilterIndex: selectedFilterIndex,
                    filters: filters,
                    onTap: sessionsCubit.changeFilterIndex,
                  );
                }),
              ),
              const Divider(
                height: 1.0,
                thickness: 1.0,
              ),
            ],
          ),
          Builder(
            builder: (context) {
              final SessionsState state =
                  context.select((SessionsCubit cubit) => cubit.state);
              return Column(mainAxisSize: MainAxisSize.min, children: [
                Padding(
                  padding: const EdgeInsets.all(
                      AppConstants.horizontalScreenPadding),
                  child: ListOfQuestionsWidget(questions: state.questions),
                ),
              ]);
            },
          )
        ]);
      }),
    );
  }
}

class _NotLiveStatusWidget extends StatelessWidget {
  final FortunicaUserStatusEnum status;

  const _NotLiveStatusWidget({
    Key? key,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeCubit homeCubit = context.read<HomeCubit>();
    return Padding(
      padding: const EdgeInsets.all(
        AppConstants.horizontalScreenPadding,
      ),
      child: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                Get.isDarkMode
                    ? Assets.images.logos.noConnectionLogoDark.image(
                        height: AppConstants.logoSize,
                        width: AppConstants.logoSize,
                      )
                    : Assets.images.logos.noConnectionLogo.image(
                        height: AppConstants.logoSize,
                        width: AppConstants.logoSize,
                      ),
                const SizedBox(
                  height: 24.0,
                ),
                Text(
                  status.errorText(),
                  style: Get.textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 16.0,
          ),
          AppElevatedButton(
            title: status.buttonText(),
            onPressed: () async {
              if (status != FortunicaUserStatusEnum.live) {
                homeCubit.changeIndex(3);
              }
            },
          )
        ],
      ),
    );
  }
}
