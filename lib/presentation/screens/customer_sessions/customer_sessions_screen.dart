import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/data/cache/caching_manager.dart';
import 'package:shared_advisor_interface/data/models/chats/chat_item.dart';
import 'package:shared_advisor_interface/data/models/enums/zodiac_sign.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/appbar/chat_conversation_app_bar.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/empty_list_widget.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/list_of_filters_widget.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/no_connection_widget.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/ok_cancel_alert.dart';
import 'package:shared_advisor_interface/presentation/resources/app_arguments.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/resources/app_routes.dart';
import 'package:shared_advisor_interface/presentation/screens/customer_sessions/customer_sessions_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/customer_sessions/widgets/customer_session_tile_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs_types.dart';

class CustomerSessionsScreen extends StatelessWidget {
  const CustomerSessionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => CustomerSessionsCubit(
              getIt.get<CachingManager>(),
              MediaQuery.of(context).size.height,
              () => showErrorAlert(context),
            ),
        child: Builder(builder: (context) {
          final CustomerSessionsCubit customerSessionsCubit =
              context.read<CustomerSessionsCubit>();
          final String? clientName = context
              .select((CustomerSessionsCubit cubit) => cubit.state.clientName);
          final ZodiacSign? zodiacSign = context
              .select((CustomerSessionsCubit cubit) => cubit.state.zodiacSign);
          return Scaffold(
              backgroundColor: Theme.of(context).canvasColor,
              appBar: ChatConversationAppBar(
                title: clientName ?? '',
                zodiacSign: zodiacSign,
              ),
              body: Builder(builder: (context) {
                final bool isOnline = context.select((MainCubit cubit) =>
                    cubit.state.internetConnectionIsAvailable);
                return Column(
                  children: [
                    const Divider(
                      height: 1,
                    ),
                    Builder(builder: (context) {
                      final int currentFilterIndex = context.select(
                          (CustomerSessionsCubit cubit) =>
                              cubit.state.currentFilterIndex);
                      return Opacity(
                        opacity: isOnline ? 1.0 : 0.4,
                        child: ListOfFiltersWidget(
                          currentFilterIndex: currentFilterIndex,
                          onTapToFilter: isOnline
                              ? customerSessionsCubit.changeFilterIndex
                              : (value) {},
                          filters: customerSessionsCubit.filters
                              .map((e) => e.filterName(context))
                              .toList(),
                        ),
                      );
                    }),
                    const Divider(
                      height: 1,
                    ),
                    Builder(builder: (context) {
                      final List<ChatItem>? questions = context.select(
                          (CustomerSessionsCubit cubit) =>
                              cubit.state.customerSessions);
                      logger.d(questions);
                      return questions == null
                          ? const SizedBox.shrink()
                          : Expanded(
                              child: isOnline
                                  ? RefreshIndicator(
                                      onRefresh: customerSessionsCubit
                                          .refreshCustomerSessions,
                                      child: CustomScrollView(
                                          controller: customerSessionsCubit
                                              .questionsController,
                                          physics:
                                              const AlwaysScrollableScrollPhysics(),
                                          slivers: [
                                            questions.isNotEmpty
                                                ? SliverToBoxAdapter(
                                                    child: ListView.separated(
                                                      padding: const EdgeInsets
                                                              .all(
                                                          AppConstants
                                                              .horizontalScreenPadding),
                                                      physics:
                                                          const NeverScrollableScrollPhysics(),
                                                      shrinkWrap: true,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        return CustomerSessionListTileWidget(
                                                            question: questions[
                                                                index]);
                                                      },
                                                      separatorBuilder:
                                                          (BuildContext context,
                                                                  int index) =>
                                                              const SizedBox(
                                                        height: 12.0,
                                                      ),
                                                      itemCount:
                                                          questions.length,
                                                    ),
                                                  )
                                                : SliverFillRemaining(
                                                    hasScrollBody: false,
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        horizontal: AppConstants
                                                            .horizontalScreenPadding,
                                                      ),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          EmptyListWidget(
                                                            title: S
                                                                .of(context)
                                                                .weDidntFindAnything,
                                                            label: S
                                                                .of(context)
                                                                .thisFilteringOptionDoesntContainAnySessions,
                                                          ),
                                                        ],
                                                      ),
                                                    ))
                                          ]),
                                    )
                                  : CustomScrollView(slivers: [
                                      SliverFillRemaining(
                                        hasScrollBody: false,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: AppConstants
                                                  .horizontalScreenPadding),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: const [
                                              NoConnectionWidget(),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ]),
                            );
                    }),
                  ],
                );
              }));
        }));
  }
}

showErrorAlert(BuildContext context) async {
  await showOkCancelAlert(
    context: context,
    title: getIt.get<MainCubit>().state.appError.getMessage(context),
    okText: S.of(context).ok,
    actionOnOK: () {
      Get.offNamedUntil(
          AppRoutes.home,
          arguments: HomeScreenArguments(
            initTab: TabsTypes.sessions,
          ),
          (route) => false);
    },
    allowBarrierClock: false,
    isCancelEnabled: false,
  );
}
