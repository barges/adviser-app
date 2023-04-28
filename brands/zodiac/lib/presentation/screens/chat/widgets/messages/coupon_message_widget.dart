import 'package:flutter/material.dart';
import 'package:zodiac/data/models/chat/chat_message_model.dart';
import 'package:zodiac/presentation/common_widgets/app_image_widget.dart';
import 'package:zodiac/presentation/screens/chat/widgets/messages/reaction_widget.dart';

class CouponMessageWidget extends StatelessWidget {
  final ChatMessageModel chatMessageModel;

  const CouponMessageWidget({
    Key? key,
    required this.chatMessageModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ReactionWidget(
            chatMessageModel: chatMessageModel,
          ),
        ),
        AppImageWidget(
          height: 96.0,
          uri: Uri.parse(chatMessageModel.image ?? ''),
          fit: BoxFit.fitHeight,
        ),
      ],
    );
  }
}
