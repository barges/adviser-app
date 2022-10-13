import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/data/cache/cache_manager.dart';
import 'package:shared_advisor_interface/data/models/user_info/fortunica_user_status.dart';
import 'package:shared_advisor_interface/data/models/user_info/user_status.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/appbar/wide_app_bar.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_elevated_button.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_icon_button.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/choose_option_widget.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/filters_list_widget.dart';
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
      create: (BuildContext context) => SessionsCubit(Get.find<CacheManager>()),
      child: Builder(builder: (BuildContext context) {
        final UserStatus userStatus =
            context.select((HomeCubit cubit) => cubit.state.userStatus);
        final SessionsCubit sessionsCubit = context.read<SessionsCubit>();

        final bool statusIsLive =
            userStatus.status == FortunicaUserStatusEnum.live;

        return Scaffold(
          backgroundColor: Get.theme.canvasColor,
          appBar: WideAppBar(
            bottomWidget: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.horizontalScreenPadding,
              ),
              child: Opacity(
                opacity: statusIsLive ? 1.0 : 0.4,
                child: Row(
                  children: [
                    Expanded(
                      child: Builder(builder: (context) {
                        final int currentIndex = context.select(
                            (SessionsCubit cubit) =>
                                cubit.state.currentOptionIndex);
                        return ChooseOptionWidget(
                          options: [S.of(context).public, S.of(context).forMe],
                          currentIndex: currentIndex,
                          onChangeOptionIndex: statusIsLive
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
          body: statusIsLive
              ? const _QuestionsListWidget()
              : _NotLiveStatusWidget(
                  status: userStatus.status ?? FortunicaUserStatusEnum.offline,
                ),
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
                height: 52.0,
                color: Get.theme.canvasColor,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Builder(builder: (context) {
                  final int selectedFilterIndex = context.select(
                      (SessionsCubit cubit) => cubit.state.selectedFilterIndex);
                  return FiltersListWidget(
                    currentFilterIndex: selectedFilterIndex,
                    filters: filters
                        .mapIndexed((element, _) => Text(element))
                        .toList(),
                    onTap: sessionsCubit.changeFilterIndex,
                  );
                }),
              ),
              SizedBox(
                  height: 1.0,
                  child: Divider(color: Get.theme.hintColor, thickness: 1))
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
