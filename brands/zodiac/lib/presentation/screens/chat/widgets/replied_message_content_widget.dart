import 'package:flutter/material.dart';
import 'package:zodiac/data/models/chat/chat_message_model.dart';
import 'package:zodiac/generated/l10n.dart';

class RepliedMessageContentWidget extends StatelessWidget {
  final ChatMessageModel repliedMessage;
  const RepliedMessageContentWidget({
    Key? key,
    required this.repliedMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${repliedMessage.authorName ?? ''}${repliedMessage.isOutgoing ? ' (${SZodiac.of(context).youZodiac})' : ''}',
          style: theme.textTheme.displaySmall?.copyWith(
            fontSize: 14.0,
            color: theme.primaryColor,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          repliedMessage.message ?? '',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.shadowColor,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
        )
      ],
    );
  }
}
