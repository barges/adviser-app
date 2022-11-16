import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_item_bg_widget.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/rect_circle_image.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_item_player.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_text_area_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_item_footer_widget.dart';

class ChatTextMediaWidget extends ChatWidget {
  const ChatTextMediaWidget({
    super.key,
    required super.item,
  });

  @override
  Widget build(BuildContext context) {
    final String? audioUrl1 = item.getAudioUrl(1);
    final String? audioUrl2 = item.getAudioUrl(2);
    return ChatItemBg(
      border: true,
      padding: paddingItem,
      color: colorItem,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ChatTextAreaWidget(
                content: item.content,
                color: getter(
                  question: Get.theme.hoverColor,
                  answer: Get.theme.backgroundColor,
                ),
              ),
              if (item.getImageUrl(1) != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: RectCircleImage(
                    item.getImageUrl(1)!,
                    height: 134.0,
                  ),
                ),
              if (item.getImageUrl(2) != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: RectCircleImage(
                    item.getImageUrl(2)!,
                    height: 134.0,
                  ),
                ),
              if (audioUrl1 == null && audioUrl2 == null)
                const SizedBox(height: 24.0),
              if ((item.getImageUrl(1) != null ||
                      item.getImageUrl(2) != null) &&
                  (audioUrl1 != null || audioUrl2 != null))
                const SizedBox(height: 12.0),
              if (audioUrl1 != null)
                ChatItemPlayer(
                  isQuestion: !item.isAnswer,
                  audioUrl: audioUrl1,
                  duration: item.getDuration(1),
                ),
              if (audioUrl2 != null)
                ChatItemPlayer(
                  isQuestion: !item.isAnswer,
                  audioUrl: audioUrl2,
                  duration: item.getDuration(2),
                ),
            ],
          ),
          Positioned(
            right: 0.0,
            bottom: 0.0,
            child: ChatItemFooterWidget(
              type: item.type!,
              createdAt: createdAt,
              ritualIdentifier: item.ritualIdentifier,
              color: getter(
                question: Get.theme.shadowColor,
                answer: Get.theme.primaryColorLight,
              ),
            ),
          )
        ],
      ),
    );
  }
}
