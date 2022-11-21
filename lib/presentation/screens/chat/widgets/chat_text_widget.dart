import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_item_footer_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_item_background_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_text_area_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_widget.dart';

class ChatTextWidget extends ChatWidget {
  const ChatTextWidget({
    super.key,
    required super.item,
  });

  @override
  Widget build(BuildContext context) {
    return ChatItemBackground(
      isBorder: true,
      padding: paddingItem,
      color: getColorItem(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: ChatTextAreaWidget(
              content: item.content,
              color: getterType(
                question: Theme.of(context).hoverColor,
                answer: Theme.of(context).backgroundColor,
              ),
            ),
          ),
          Row(
            children: [
              const Spacer(),
              ChatItemFooterWidget(
                type: item.type!,
                createdAt: createdAt,
                ritualIdentifier: item.ritualIdentifier,
                color: getterType(
                  question: Theme.of(context).shadowColor,
                  answer: Theme.of(context).primaryColorLight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
