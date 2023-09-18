import 'package:flutter/material.dart';
import 'package:zodiac/data/models/chat/chat_message_model.dart';
import 'package:zodiac/data/models/chat/replied_message.dart';
import 'package:zodiac/generated/l10n.dart';

class RepliedMessageContentWidget extends StatelessWidget {
  final ChatMessageModel? chatMessageModel;
  final RepliedMessage? repliedMessage;
  final Color authorNameColor;
  final Color messageColor;

  const RepliedMessageContentWidget({
    Key? key,
    required this.authorNameColor,
    required this.messageColor,
    this.chatMessageModel,
    this.repliedMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    String authorName = chatMessageModel != null
        ? '${chatMessageModel?.authorName ?? ''}${chatMessageModel?.isOutgoing == true ? ' (${SZodiac.of(context).youZodiac})' : ''}'
        : repliedMessage?.repliedUserName ?? '';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          authorName,
          style: theme.textTheme.displaySmall?.copyWith(
            fontSize: 14.0,
            color: authorNameColor,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          repliedMessage?.type.getTitle(context) ?? '',
          style: theme.textTheme.bodySmall?.copyWith(
            color: messageColor,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
        )
      ],
    );
  }
}
