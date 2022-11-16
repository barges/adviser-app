import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_item_footer_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_item_bg_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_text_area_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_widget.dart';

class ChatTextWidget extends ChatWidget {
  const ChatTextWidget({
    super.key,
    required super.item,
  });

  @override
  Widget build(BuildContext context) {
    return ChatItemBg(
      border: true,
      padding: paddingItem,
      color: colorItem,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: ChatTextAreaWidget(
              content: item.content,
              color: getter(
                question: Get.theme.hoverColor,
                answer: Get.theme.backgroundColor,
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
                color: getter(
                  question: Get.theme.shadowColor,
                  answer: Get.theme.primaryColorLight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
