import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/domain/repositories/sessions_repository.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/app_loading_indicator.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/appbar/wide_app_bar.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/choose_option_widget.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/filters_widget.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/screens/drawer/app_drawer.dart';
import 'package:shared_advisor_interface/presentation/screens/home/home_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/sessions/sessions_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/sessions/sessions_state.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/sessions/widgets/list_of_questions_widget.dart';

class SessionsScreen extends StatelessWidget {
  const SessionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeCubit homeCubit = context.read<HomeCubit>();
    return BlocProvider(
      create: (BuildContext context) =>
          SessionsCubit(Get.find<SessionsRepository>()),
      child: Builder(builder: (BuildContext context) {
        final SessionsCubit chatsCubit = context.read<SessionsCubit>();
        return Scaffold(
          key: chatsCubit.scaffoldKey,
          drawer: const AppDrawer(),
          backgroundColor: Get.theme.canvasColor,
          appBar: WideAppBar(
            bottomWidget: Row(
              children: [
                Expanded(
                  child: Builder(builder: (context) {
                    final int currentIndex = context.select(
                        (SessionsCubit cubit) =>
                            cubit.state.currentOptionIndex);
                    return ChooseOptionWidget(
                        options: [S.of(context).public, S.of(context).forMe],
                        currentIndex: currentIndex,
                        onChangeOptionIndex: chatsCubit.getListOfQuestions);
                  }),
                ),
                const SizedBox(width: 8.0),
                InkResponse(
                  onTap: () {},
                  child: Ink(
                    padding: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                        color: Get.theme.scaffoldBackgroundColor,
                        borderRadius:
                            BorderRadius.circular(AppConstants.buttonRadius)),
                    child: Assets.vectors.search.svg(width: 24.0),
                  ),
                )
              ],
            ),
            withBrands: true,
          ),
          body: SingleChildScrollView(
            controller: chatsCubit.controller,
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
                            (SessionsCubit cubit) =>
                                cubit.state.selectedFilterIndex);
                        return FiltersWidget(
                          currentFilterIndex: selectedFilterIndex,
                          filters: filters
                              .mapIndexed((element, _) => Text(element))
                              .toList(),
                          onTap: chatsCubit.changeFilterIndex,
                          itemPadding: const EdgeInsets.symmetric(
                              vertical: 6.0,
                              horizontal: AppConstants.horizontalScreenPadding),
                        );
                      }),
                    ),
                    SizedBox(
                        height: 1.0,
                        child:
                            Divider(color: Get.theme.hintColor, thickness: 1))
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
                        child:
                            ListOfQuestionsWidget(questions: state.questions),
                      ),
                      if (state.isLoading)
                        SizedBox(
                            height: Get.height / 2,
                            child: const Center(
                                child:
                                    AppLoadingIndicator(showIndicator: true)))
                    ]);
                  },
                )
              ]);
            }),
          ),
        );
      }),
    );
  }
}
