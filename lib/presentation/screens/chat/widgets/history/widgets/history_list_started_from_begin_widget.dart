import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/data/models/chats/history_ui_model.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/history/history_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/history/widgets/history_list_group_header.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/history/widgets/question_and_answer_pair_widget.dart';

class HistoryListStartedFromBeginWidget extends StatelessWidget {
  final List<HistoryUiModel> historiesList;

  const HistoryListStartedFromBeginWidget({
    Key? key,
    required this.historiesList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HistoryCubit historyCubit = context.read<HistoryCubit>();

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: ListView.builder(
          controller: historyCubit.historyMessagesScrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 16.0),
          itemCount: historiesList.length,
          shrinkWrap: true,
          itemBuilder: (_, index) {
            return historiesList[index].when(
              data: (data) => QuestionAndAnswerPairWidget(
                historyItem: data,
              ),
              separator: (question) => HistoryListGroupHeader(
                question: question,
              ),
            );
          }),
    );
  }
}
