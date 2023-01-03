import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/data/models/chats/chat_item.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_media_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_text_media_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_text_widget.dart';

class ChatItemWidget extends StatelessWidget {
  final ChatItem item;
  final VoidCallback? onPressedTryAgain;
  final bool isHistoryQuestion;
  final bool isHistoryAnswer;

  const ChatItemWidget(
    this.item, {
    Key? key,
    this.onPressedTryAgain,
    this.isHistoryQuestion = false,
    this.isHistoryAnswer = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (item.attachments?.isNotEmpty == true) {
      if (item.content?.isNotEmpty == true) {
        return ChatTextMediaWidget(
          item: item,
          onPressedTryAgain: onPressedTryAgain,
          isHistoryQuestion: isHistoryQuestion,
          isHistoryAnswer: isHistoryAnswer,
        );
      } else {
        return ChatMediaWidget(
          item: item,
          onPressedTryAgain: onPressedTryAgain,
          isHistoryQuestion: isHistoryQuestion,
          isHistoryAnswer: isHistoryAnswer,
        );
      }
    } else {
      return ChatTextWidget(
        item: item,
        onPressedTryAgain: onPressedTryAgain,
        isHistoryQuestion: isHistoryQuestion,
        isHistoryAnswer: isHistoryAnswer,
      );
    }
  }
}
