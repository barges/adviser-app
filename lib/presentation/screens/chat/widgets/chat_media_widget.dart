import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_item_bg_widget.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/rect_circle_image.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_item_player.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_item_footer_widget.dart';

class ChatMediaWidget extends ChatWidget {
  const ChatMediaWidget({
    super.key,
    required super.item,
  });

  @override
  Widget build(BuildContext context) {
    final String? audioUrl1 = item.getAudioUrl(1);
    final String? audioUrl2 = item.getAudioUrl(2);
    return ChatItemBg(
      padding: paddingItem,
      color: getColorItem(context),
      child: Stack(
        children: [
          Column(
            children: [
              if (item.getImageUrl(1) != null)
                RectCircleImage(
                  item.getImageUrl(1)!,
                  height: 134.0,
                ),
              if (item.getImageUrl(2) != null)
                Padding(
                  padding: EdgeInsets.only(
                      top: item.getImageUrl(1) != null ? 12.0 : 0.0),
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
              color: getterType(
                question: Theme.of(context).shadowColor,
                answer: Theme.of(context).primaryColorLight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
