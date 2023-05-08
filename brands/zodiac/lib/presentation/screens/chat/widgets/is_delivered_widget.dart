import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:zodiac/data/models/chat/chat_message_model.dart';

class IsDeliveredWidget extends StatelessWidget {
  final ChatMessageModel chatMessageModel;
  final Color color;

  const IsDeliveredWidget({
    Key? key,
    required this.chatMessageModel,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return chatMessageModel.isOutgoing
        ? chatMessageModel.isRead
            ? Padding(
                padding: const EdgeInsets.only(
                  left: 2.0,
                ),
                child: Assets.zodiac.isRead.svg(
                  height: 12.0,
                  width: 12.0,
                  color: color,
                ),
              )
            : chatMessageModel.isDelivered
                ? Padding(
                    padding: const EdgeInsets.only(
                      left: 2.0,
                    ),
                    child: Assets.zodiac.delivered.svg(
                      height: 12.0,
                      width: 12.0,
                      color: color,
                    ),
                  )
                : const SizedBox.shrink()
        : const SizedBox.shrink();
  }
}
