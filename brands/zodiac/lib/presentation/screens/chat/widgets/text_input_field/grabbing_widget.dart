import 'package:flutter/material.dart';
import 'package:zodiac/data/models/chat/chat_message_model.dart';
import 'package:zodiac/presentation/screens/chat/widgets/text_input_field/chat_text_input_widget.dart';
import 'package:zodiac/presentation/screens/chat/widgets/text_input_field/replied_message_widget.dart';

class GrabbingWidget extends StatelessWidget {
  final ChatMessageModel? repliedMessage;

  const GrabbingWidget({
    Key? key,
    this.repliedMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: MediaQuery.of(context).size.width,
      height: repliedMessage != null
          ? constGrabbingHeight + repliedMessageHeight
          : constGrabbingHeight,
      decoration: BoxDecoration(
        color: theme.canvasColor,
        boxShadow: [
          BoxShadow(
            blurRadius: 2.0,
            spreadRadius: 2.0,
            color: theme.canvasColor,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (repliedMessage != null)
            RepliedMessageWidget(),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 1.0,
            color: theme.hintColor,
          ),
          Container(
            margin: const EdgeInsets.only(top: 5.0),
            height: 4.0,
            width: 48.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(90.0),
              color: theme.hintColor,
            ),
          ),
          const SizedBox(height: 6.0)
        ],
      ),
    );
  }
}
