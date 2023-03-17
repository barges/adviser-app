import 'package:flutter/material.dart';
import 'package:fortunica/data/models/chats/history.dart';
import 'package:fortunica/presentation/screens/chat/widgets/chat_item_widget.dart';

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
        if (historyItem.question != null)
          Column(
            children: [
              const SizedBox(
                height: 8.0,
              ),
              ChatItemWidget(
                item: historyItem.question!,
              ),
            ],
          ),
        if (historyItem.answer != null)
          Column(
            children: [
              const SizedBox(
                height: 8.0,
              ),
              ChatItemWidget(
                item: historyItem.answer!.copyWith(
                  isAnswer: true,
                  ritualIdentifier: historyItem.question?.ritualIdentifier,
                  type: historyItem.question?.type,
                ),
              ),
            ],
          ),
      ],
    );
  }
}
