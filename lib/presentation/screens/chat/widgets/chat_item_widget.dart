import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/data/models/chats/chat_item.dart';
import 'package:shared_advisor_interface/data/models/enums/attachment_type.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/rounded_rect_image.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_item_background_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_item_footer_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_item_player.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_text_area_widget.dart';

class ChatItemWidget extends StatelessWidget {
  final ChatItem item;
  final VoidCallback? onPressedTryAgain;
  final bool isHistoryQuestion;
  final bool isHistoryAnswer;

  const ChatItemWidget({
    super.key,
    required this.item,
    this.onPressedTryAgain,
    this.isHistoryQuestion = false,
    this.isHistoryAnswer = false,
  });

  @override
  Widget build(BuildContext context) {
    return ChatItemBackground(
      onPressedTryAgain: onPressedTryAgain,
      isTryAgain: !item.isSent,
      padding: item.isAnswer
          ? const EdgeInsets.only(left: 36.0)
          : const EdgeInsets.only(right: 36.0),
      color: item.isAnswer
          ? Theme.of(context).primaryColor
          : Theme.of(context).canvasColor,
      child: Stack(children: [
        Column(crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
          if (item.content?.isNotEmpty == true)
            ChatTextAreaWidget(
              content: item.content!,
              color: item.isAnswer
                  ? Theme.of(context).backgroundColor
                  : Theme.of(context).hoverColor,
            ),
          if (item.attachments?.isNotEmpty == true)
            Column(
              children: item.attachments!.map((e) {
                if (e.type == AttachmentType.image) {
                  return RoundedRectImage(
                    uri: Uri.parse(e.url ?? ''),
                    height: 134.0,
                  );
                } else if (e.type == AttachmentType.audio) {
                  return ChatItemPlayer(
                    isQuestion: !item.isAnswer,
                    attachment: e,
                  );
                }

                return const SizedBox();
              }).toList(),
            ),
        ]),
        Positioned(
          right: 0.0,
          bottom: 0.0,
          child: ChatItemFooterWidget(
            type: item.type,
            createdAt: item.createdAt ?? DateTime.now(),
            ritualIdentifier: item.ritualIdentifier,
            color: item.isAnswer
                ? Theme.of(context).primaryColorLight
                : Theme.of(context).shadowColor,
            isHistoryQuestion: isHistoryQuestion,
            isHistoryAnswer: isHistoryAnswer,
          ),
        ),
      ]
          // if (isImage1)
          //   RoundedRectImage(
          //     uri: Uri.parse(item.getImageUrl(1)!),
          //     height: 134.0,
          //   ),
          // if (isImage2)
          //   Padding(
          //     padding: const EdgeInsets.only(top: 12.0,),
          //     child: RoundedRectImage(
          //       uri: Uri.parse(item.getImageUrl(2)!),
          //       height: 134.0,
          //     ),
          //   ),
          // if (audioUrl1 == null && audioUrl2 == null)
          //   const SizedBox(height: 24.0),
          // if ((isImage1 || isImage2) &&
          //     (audioUrl1 != null || audioUrl2 != null))
          //   const SizedBox(height: 12.0),
          // if (audioUrl1 != null)
          //   ChatItemPlayer(
          //     isQuestion: !item.isAnswer,
          //     audioUrl: audioUrl1,
          //     duration: item.getDuration(1),
          //   ),
          // if (audioUrl2 != null)
          //   ChatItemPlayer(
          //     isQuestion: !item.isAnswer,
          //     audioUrl: audioUrl2,
          //     duration: item.getDuration(2),
          //   ),

          ),
    );
  }
}
