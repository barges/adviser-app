import 'package:flutter/material.dart';
import 'package:fortunica/data/models/chats/history_ui_model.dart';
import 'package:fortunica/presentation/screens/chat/widgets/history/widgets/history_list_group_header.dart';
import 'package:fortunica/presentation/screens/chat/widgets/history/widgets/question_and_answer_pair_widget.dart';

class SliverHistoryListWidget extends StatelessWidget {
  final List<HistoryUiModel> historiesList;
  const SliverHistoryListWidget({Key? key, required this.historiesList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return historiesList[index].when(
            data: (data) => QuestionAndAnswerPairWidget(
              historyItem: data,
            ),
            separator: (question) => HistoryListGroupHeader(
              question: question,
            ),
          );
        },
        childCount: historiesList.length,
      ),
    );
  }
}
