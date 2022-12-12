import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_item_background_widget.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/rounded_rect_image.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_item_player.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_item_footer_widget.dart';

class ChatMediaWidget extends ChatWidget {
  final VoidCallback? onPressedTryAgain;
  const ChatMediaWidget({
    super.key,
    required super.item,
    this.onPressedTryAgain,
  });

  @override
  Widget build(BuildContext context) {
    final String? audioUrl1 = item.getAudioUrl(1);
    final String? audioUrl2 = item.getAudioUrl(2);
    final bool isImage1 = item.getImageUrl(1) != null;
    final bool isImage2 = item.getImageUrl(2) != null;

    return ChatItemBackground(
      onPressedTryAgain: onPressedTryAgain,
      isTryAgain: !item.isSent,
      padding: paddingItem,
      color: getColorItem(context),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (isImage1)
                RoundedRectImage(
                  uri: Uri.parse(item.getImageUrl(1)!),
                  height: 134.0,
                ),
              if (isImage2)
                Padding(
                  padding: EdgeInsets.only(top: isImage2 ? 12.0 : 0.0),
                  child: RoundedRectImage(
                    uri: Uri.parse(item.getImageUrl(2)!),
                    height: 134.0,
                  ),
                ),
              if (audioUrl1 == null && audioUrl2 == null)
                const SizedBox(height: 24.0),
              if ((isImage1 || isImage2) &&
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
              type: item.type,
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
