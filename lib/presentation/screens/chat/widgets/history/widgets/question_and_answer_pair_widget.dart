import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/data/models/chats/history.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_item_widget.dart';

class QuestionAndAnswerPairWidget extends StatelessWidget {
  final History historyItem;
  const QuestionAndAnswerPairWidget({
    Key? key,
    required this.historyItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (historyItem.question != null) ChatItemWidget(historyItem.question!),
        if (historyItem.answer != null)
          ChatItemWidget(historyItem.answer!.copyWith(
              isAnswer: true,
              ritualIdentifier: historyItem.question?.ritualIdentifier,
              type: historyItem.question?.type)),
      ],
    );
  }
}
