import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/data/cache/caching_manager.dart';
import 'package:shared_advisor_interface/data/models/chats/chat_item.dart';
import 'package:shared_advisor_interface/data/models/enums/zodiac_sign.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/appbar/chat_conversation_app_bar.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/empty_list_widget.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/list_of_filters_widget.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/screens/customer_sessions/customer_sessions_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/customer_sessions/widgets/customer_session_tile_widget.dart';

class CustomerSessionsScreen extends StatelessWidget {
  const CustomerSessionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) =>
            CustomerSessionsCubit(getIt.get<CachingManager>(), context),
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
              body: Column(
                children: [
                  const Divider(
                    height: 1,
                  ),
                  Builder(builder: (context) {
                    final int currentFilterIndex = context.select(
                        (CustomerSessionsCubit cubit) =>
                            cubit.state.currentFilterIndex);
                    return ListOfFiltersWidget(
                      currentFilterIndex: currentFilterIndex,
                      onTapToFilter: customerSessionsCubit.changeFilterIndex,
                      filters: customerSessionsCubit.filters
                          .map((e) => e.filterName(context))
                          .toList(),
                    );
                  }),
                  const Divider(
                    height: 1,
                  ),
                  Builder(builder: (context) {
                    final List<ChatItem>? questions = context.select(
                        (CustomerSessionsCubit cubit) =>
                            cubit.state.sessionsQuestions);
                    logger.d(questions);
                    return questions == null
                        ? const SizedBox.shrink()
                        : Expanded(
                            child: CustomScrollView(
                                controller:
                                    customerSessionsCubit.questionsController,
                                physics: const AlwaysScrollableScrollPhysics(),
                                slivers: [
                                  questions.isNotEmpty
                                      ? SliverToBoxAdapter(
                                          child: ListView.separated(
                                            padding: const EdgeInsets.all(
                                                AppConstants
                                                    .horizontalScreenPadding),
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return CustomerSessionListTileWidget(
                                                  question: questions[index]);
                                            },
                                            separatorBuilder:
                                                (BuildContext context,
                                                        int index) =>
                                                    Column(
                                              children: const [
                                                SizedBox(
                                                  height: 16.0,
                                                ),
                                                Divider(
                                                  height: 1.0,
                                                ),
                                                SizedBox(
                                                  height: 16.0,
                                                ),
                                              ],
                                            ),
                                            itemCount: questions.length,
                                          ),
                                        )
                                      : SliverFillRemaining(
                                          hasScrollBody: true,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: AppConstants
                                                  .horizontalScreenPadding,
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
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
                          );
                  }),
                ],
              ));
        }));
  }
}
