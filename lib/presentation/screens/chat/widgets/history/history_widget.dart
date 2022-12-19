import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:shared_advisor_interface/data/models/chats/history.dart';
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
    return BlocProvider(
      create: (_) => HistoryCubit(
        getIt.get<ChatsRepository>(),
        clientId,
        playerMedia,
        storyId,
      ),
      child: Builder(builder: (context) {
        final HistoryCubit historyCubit = context.read<HistoryCubit>();
        final List<History>? historyList =
            context.select((HistoryCubit cubit) => cubit.state.historyMessages);
        return Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Builder(builder: (context) {
              return CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: historyCubit.historyMessagesScrollController,
                  slivers: [
                    historyList == null
                        ? const SliverToBoxAdapter(child: SizedBox.shrink())
                        : historyList.isNotEmpty
                            ? SliverToBoxAdapter(
                                child: GroupedListView<History, String?>(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  elements: historyList,
                                  sort: false,
                                  reverse: true,
                                  groupBy: (element) {
                                    return element.question?.storyID;
                                  },
                                  groupHeaderBuilder: (History value) =>
                                      HistoryListGroupHeader(
                                          headerItem: value,
                                          key: historyList.indexOf(value) ==
                                                  historyList.length -
                                                      historyCubit.offset -
                                                      1
                                              ? historyCubit.scrollItemKey
                                              : null),
                                  indexedItemBuilder:
                                      (context, element, index) =>
                                          QuestionAndAnswerPairWidget(
                                    historyItem: element,
                                  ),
                                  shrinkWrap: true,
                                ),
                              )
                            : SliverFillRemaining(
                                hasScrollBody: false,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal:
                                        AppConstants.horizontalScreenPadding,
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
                                )),
                  ]);
            }));
      }),
    );
  }
}
