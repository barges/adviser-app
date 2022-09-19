import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/configuration.dart';
import 'package:shared_advisor_interface/domain/repositories/sessions_repository.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/main_cibit.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/app_loading_indicator.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/change_locale_button.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/screens/drawer/app_drawer.dart';
import 'package:shared_advisor_interface/presentation/screens/home/home_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/sessions/sessions_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/sessions/sessions_state.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/list_of_filters_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/sessions/widgets/list_of_questions_widget.dart';

class SessionsScreen extends StatelessWidget {
  const SessionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SessionsCubit(Get.find<SessionsRepository>()),
      child: Builder(builder: (BuildContext context) => const _BuildUI()),
    );
  }
}

class _BuildUI extends StatelessWidget {
  const _BuildUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SessionsCubit chatsCubit = context.read<SessionsCubit>();
    final HomeCubit homeCubit = context.read<HomeCubit>();
    final Brand selectedBrand =
        context.select((MainCubit cubit) => cubit.state.currentBrand);

    return Scaffold(
      key: chatsCubit.scaffoldKey,
      drawer: const AppDrawer(),
      backgroundColor: Get.theme.canvasColor,
      appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 96.0,
          elevation: 0.2,
          flexibleSpace: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.horizontalScreenPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: homeCubit.openDrawer,
                        child: Builder(
                            builder: (context) => Row(
                                  children: [
                                    Container(
                                      height: 32.0,
                                      width: 32.0,
                                      padding: const EdgeInsets.all(4.0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            AppConstants.buttonRadius),
                                        color:
                                            Get.theme.scaffoldBackgroundColor,
                                      ),
                                      child:
                                          SvgPicture.asset(selectedBrand.icon),
                                    ),
                                    const SizedBox(width: 8.0),
                                    Text(selectedBrand.name,
                                        style: Get.textTheme.headlineMedium)
                                  ],
                                )),
                      ),
                      const ChangeLocaleButton()
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: Get.width * 0.8,
                        decoration: BoxDecoration(
                            color: Get.theme.scaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(
                                AppConstants.buttonRadius)),
                        child: Stack(
                          alignment: Alignment.centerLeft,
                          fit: StackFit.loose,
                          children: [
                            Row(
                              children: [
                                IsPublicWidget(
                                    title: S.of(context).public,
                                    onTap: chatsCubit.getListOfQuestions),
                                IsPublicWidget(
                                    title: S.of(context).forMe,
                                    onTap: chatsCubit.getListOfQuestions)
                              ],
                            ),
                            Builder(builder: (context) {
                              final bool isPublic = context.select(
                                  (SessionsCubit cubit) => cubit.state.isPublic);
                              return AnimatedAlign(
                                  alignment: isPublic
                                      ? Alignment.centerLeft
                                      : Alignment.centerRight,
                                  duration: const Duration(seconds: 1),
                                  child: Container(
                                      width: Get.width * 0.4,
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 6.0),
                                      decoration: BoxDecoration(
                                          color: Get.theme.primaryColor,
                                          borderRadius: BorderRadius.circular(
                                              AppConstants.buttonRadius)),
                                      child: Text(
                                        chatsCubit.buildIsPublicText(),
                                        style: Get.textTheme.titleMedium
                                            ?.copyWith(
                                                fontWeight: FontWeight.w500,
                                                color:
                                                    Get.theme.backgroundColor),
                                      )));
                            }),
                          ],
                        ),
                      ),
                      InkResponse(
                        onTap: () {},
                        child: Ink(
                          padding: const EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                              color: Get.theme.scaffoldBackgroundColor,
                              borderRadius: BorderRadius.circular(
                                  AppConstants.buttonRadius)),
                          child: Assets.vectors.search.svg(width: 24.0),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          )),
      body: SingleChildScrollView(
        controller: chatsCubit.controller,
        child: Builder(builder: (context) {
          final SessionsState state =
              context.select((SessionsCubit cubit) => cubit.state);
          final int selectedFilterIndex = context
              .select((SessionsCubit cubit) => cubit.state.selectedFilterIndex);
          final List<String> filters = [
            S.of(context).all,
            S.of(context).onlyPremiumProducts,
            S.of(context).privateQuestions,
            '${S.of(context).market}: '
          ];
          final List<VoidCallback> onTaps = filters
              .map(
                  (e) => () => chatsCubit.changeFilterIndex(filters.indexOf(e)))
              .toList();
          return Column(children: [
            ListOfFiltersWidget(
                currentFilterIndex: selectedFilterIndex,
                filters: filters,
                onTaps: onTaps),
            state.isLoading
                ? SizedBox(
                    height: Get.height / 2,
                    child: const Center(child: AppLoadingIndicator()))
                : Padding(
                    padding: const EdgeInsets.all(AppConstants.horizontalScreenPadding),
                    child: ListOfQuestionsWidget(
                        questions: state.questionsListResponse.questions ?? []),
                  )
          ]);
        }),
      ),
    );
  }
}

class IsPublicWidget extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;

  const IsPublicWidget({Key? key, required this.title, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
      child: Container(
        alignment: Alignment.center,
        width: Get.width * 0.4,
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Text(
          title,
          maxLines: 1,
          style: Get.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500, color: Get.theme.primaryColor),
        ),
      ),
    );
  }
}
