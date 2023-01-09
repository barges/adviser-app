import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/data/models/chats/chat_item.dart';
import 'package:shared_advisor_interface/data/models/enums/attachment_type.dart';
import 'package:shared_advisor_interface/extensions.dart';
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
    return ChatItemBackgroundWidget(
      onPressedTryAgain: onPressedTryAgain,
      isTryAgain: !item.isSent,
      padding: item.isAnswer
          ? const EdgeInsets.only(left: 36.0)
          : const EdgeInsets.only(right: 36.0),
      color: item.isAnswer
          ? Theme.of(context).primaryColor
          : Theme.of(context).canvasColor,
      child: Stack(children: [
        Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          if (item.content?.isNotEmpty == true)
            Padding(
              padding: EdgeInsets.only(
                  bottom: item.attachments?.isNotEmpty == true ? 5.0 : 18.0),
              child: ChatTextAreaWidget(
                content: item.content!,
                color: item.isAnswer
                    ? Theme.of(context).backgroundColor
                    : Theme.of(context).hoverColor,
              ),
            ),
          if (item.attachments?.isNotEmpty == true)
            Column(
              children: item.attachments!.mapIndexed((attachment, index) {
                if (attachment.type == AttachmentType.image) {
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: item.attachments!.length > 1 &&
                              index < item.attachments!.length - 1
                          ? 12.0
                          : 20.0,
                    ),
                    child: RoundedRectImage(
                      uri: Uri.parse(attachment.url ?? ''),
                      height: 134.0,
                      canBeOpenedInFullScreen: true,
                    ),
                  );
                } else if (attachment.type == AttachmentType.audio) {
                  return ChatItemPlayer(
                    isQuestion: !item.isAnswer,
                    attachment: attachment,
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
      ]),
    );
  }
}
