import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:shared_advisor_interface/data/models/chats/history_ui_model.dart';
import 'package:shared_advisor_interface/domain/repositories/chats_repository.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/empty_list_widget.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/history/history_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/history/widgets/history_list_group_header.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/history/widgets/question_and_answer_pair_widget.dart';

class HistoryWidget extends StatelessWidget {
  final String clientId;
  final FlutterSoundPlayer playerMedia;
  final String? storyId;

  const HistoryWidget({
    Key? key,
    required this.clientId,
    required this.playerMedia,
    this.storyId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Key centerKey = ValueKey('second-sliver-list');
    return BlocProvider(
      create: (_) => HistoryCubit(
        getIt.get<ChatsRepository>(),
        clientId,
        playerMedia,
        storyId,
      ),
      child: Builder(builder: (context) {
        final HistoryCubit historyCubit = context.read<HistoryCubit>();

        if (storyId != null) {
          final List<HistoryUiModel>? topHistoriesList = context
              .select((HistoryCubit cubit) => cubit.state.topHistoriesList);

          if (topHistoriesList == null) {
            return Container(
              color: Theme.of(context).scaffoldBackgroundColor,
            );
          }
          if (topHistoriesList.isEmpty) {
            return Container(
              color: Theme.of(context).canvasColor,
              child: CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.horizontalScreenPadding,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          EmptyListWidget(
                            title: S.of(context).noSessionsYet,
                            label: S
                                .of(context)
                                .whenYouHelpYourFirstClientYouWillSeeYourSessionHistoryHere,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              reverse: true,
              controller: historyCubit.historyMessagesScrollController,
              center: centerKey,
              slivers: <Widget>[
                Builder(builder: (context) {
                  final List<HistoryUiModel>? bottomHistoriesList =
                      context.select((HistoryCubit cubit) =>
                          cubit.state.bottomHistoriesList);
                  if (bottomHistoriesList != null) {
                    return SliverPadding(
                      padding: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 16.0),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            return bottomHistoriesList[index].when(
                              data: (data) => QuestionAndAnswerPairWidget(
                                historyItem: data,
                              ),
                              separator: (question) => HistoryListGroupHeader(
                                question: question,
                              ),
                            );
                          },
                          childCount: bottomHistoriesList.length,
                        ),
                      ),
                    );
                  } else {
                    return const SliverToBoxAdapter(
                      child: SizedBox.shrink(),
                    );
                  }
                }),
                SliverPadding(
                  key: centerKey,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return topHistoriesList[index].when(
                          data: (data) => QuestionAndAnswerPairWidget(
                            historyItem: data,
                          ),
                          separator: (question) => HistoryListGroupHeader(
                            question: question,
                          ),
                        );
                      },
                      childCount: topHistoriesList.length,
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          final List<HistoryUiModel>? bottomHistoriesList = context
              .select((HistoryCubit cubit) => cubit.state.bottomHistoriesList);

          if (bottomHistoriesList == null) {
            return Container(
              color: Theme.of(context).scaffoldBackgroundColor,
            );
          }
          if (bottomHistoriesList.isEmpty) {
            return Container(
              color: Theme.of(context).canvasColor,
              child: CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.horizontalScreenPadding,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          EmptyListWidget(
                            title: S.of(context).noSessionsYet,
                            label: S
                                .of(context)
                                .whenYouHelpYourFirstClientYouWillSeeYourSessionHistoryHere,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: SingleChildScrollView(
              controller: historyCubit.historyMessagesScrollController,
              child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 16.0),
                  itemCount: bottomHistoriesList.length,
                  shrinkWrap: true,
                  itemBuilder: (_, index) {
                    return bottomHistoriesList[index].when(
                      data: (data) => QuestionAndAnswerPairWidget(
                        historyItem: data,
                      ),
                      separator: (question) => HistoryListGroupHeader(
                        question: question,
                      ),
                    );
                  }),
            ),
          );
        }
      }),
    );
  }
}
