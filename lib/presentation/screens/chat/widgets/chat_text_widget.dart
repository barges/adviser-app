import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_item_bg_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_text_area_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/footer_chat_widget.dart';

class ChatTextWidget extends ChatWidget {
  final String? content;
  const ChatTextWidget({
    super.key,
    required super.isQuestion,
    required super.createdAt,
    required super.type,
    super.ritualIdentifier,
    this.content = '',
  });

  @override
  Widget build(BuildContext context) {
    return ChatItemBg(
      border: true,
      padding: getter(
        question: const EdgeInsets.fromLTRB(12.0, 4.0, 48.0, 4.0),
        answer: const EdgeInsets.fromLTRB(48.0, 4.0, 12.0, 4.0),
      ),
      color: getter(
        question: Get.theme.canvasColor,
        answer: Get.theme.primaryColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ChatTextAreaWidget(
            content: content,
            color: getter(
              question: Get.theme.hoverColor,
              answer: Get.theme.backgroundColor,
            ),
          ),
          const SizedBox(
            width: 5.0,
          ),
          Row(
            children: [
              const Spacer(),
              FooterChatWidget(
                type: type,
                createdAt: createdAt,
                ritualIdentifier: ritualIdentifier,
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
