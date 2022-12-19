import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:shared_advisor_interface/data/models/chats/history.dart';
import 'package:shared_advisor_interface/domain/repositories/chats_repository.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/history/history_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/history/widgets/question_and_answer_pair_widget.dart';
import 'package:shared_advisor_interface/extensions.dart';

class HistoryTab extends StatelessWidget {
  final String clientId;
  final FlutterSoundPlayer playerMedia;
  final String? storyId;

  const HistoryTab({
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
        final List<History> historyList =
            context.select((HistoryCubit cubit) => cubit.state.historyMessages);
        return Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: GroupedListView<History, String?>(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              elements: historyList,
              controller: historyCubit.historyMessagesScrollController,
              groupBy: (element) {
                return element.question?.storyID;
              },
              groupHeaderBuilder: (History? value) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  children: [
                    const Expanded(
                      child: Divider(
                        height: 1,
                      ),
                    ),
                    Text(
                        value?.question?.ritualIdentifier
                                ?.sessionName(context) ??
                            value?.question?.type?.typeName(context) ??
                            '',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontSize: 12.0,
                              color: Theme.of(context).shadowColor,
                            )),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: SvgPicture.asset(
                        value?.question?.ritualIdentifier != null
                            ? value!.question!.ritualIdentifier!.iconPath
                            : value?.question?.type?.iconPath ?? '',
                        width: 16.0,
                        height: 16.0,
                        color: Theme.of(context).shadowColor,
                      ),
                    ),
                    Text(
                        value?.question?.createdAt?.historyListTime(context) ??
                            '',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontSize: 12.0,
                              color: Theme.of(context).shadowColor,
                            )),
                    const Expanded(
                      child: Divider(
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
              indexedItemBuilder: (context, element, index) =>
                  QuestionAndAnswerPairWidget(historyItem: element),
              shrinkWrap: true,
            ));
      }),
    );
  }
}
