import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:zodiac/data/models/chat/chat_message_model.dart';
import 'package:zodiac/presentation/screens/chat/widgets/chat_message/chat_message_widget.dart';

class ReactionFeatureWrapper extends StatefulWidget {
  final ChatMessageModel chatMessageModel;

  const ReactionFeatureWrapper({Key? key, required this.chatMessageModel})
      : super(key: key);

  @override
  State<ReactionFeatureWrapper> createState() => _ReactionFeatureWrapperState();
}

class _ReactionFeatureWrapperState extends State<ReactionFeatureWrapper> {
  final GlobalKey key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => logger.d('Hold'),
      child: ChatMessageWidget(
        key: key,
        chatMessageModel: widget.chatMessageModel,
      ),
    );
  }
}
