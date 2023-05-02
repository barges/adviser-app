import 'package:flutter/material.dart';
import 'package:zodiac/data/models/chat/chat_message_model.dart';

const double reactionContainerWidth = 36.0;

class ReactionWidget extends StatelessWidget {
  final ChatMessageModel chatMessageModel;

  const ReactionWidget({
    Key? key,
    required this.chatMessageModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isOutgoing = chatMessageModel.isOutgoing;

    return Row(
      mainAxisAlignment:
      isOutgoing ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: const [
        SizedBox(
          width: reactionContainerWidth,
          height: reactionContainerWidth,
        ),
      ],
    );
  }
}