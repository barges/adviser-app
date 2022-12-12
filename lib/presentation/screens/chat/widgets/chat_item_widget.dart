import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/data/models/chats/chat_item.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_media_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_text_media_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_text_widget.dart';

class ChatItemWidget extends StatelessWidget {
  final ChatItem item;
  final VoidCallback? onPressedTryAgain;

  const ChatItemWidget(
    this.item, {
    Key? key,
    this.onPressedTryAgain,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (item.isMedia) {
      if (item.content != null && item.content!.isNotEmpty) {
        return ChatTextMediaWidget(
          item: item,
          onPressedTryAgain: onPressedTryAgain,
        );
      } else {
        return ChatMediaWidget(
          item: item,
          onPressedTryAgain: onPressedTryAgain,
        );
      }
    } else {
      return ChatTextWidget(
        item: item,
        onPressedTryAgain: onPressedTryAgain,
      );
    }
  }
}
