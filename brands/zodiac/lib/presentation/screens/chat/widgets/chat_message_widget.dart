import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:zodiac/data/models/chat/chat_message_model.dart';
import 'package:zodiac/data/models/enums/chat_message_type.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/screens/chat/widgets/messages/coupon_message_widget.dart';
import 'package:zodiac/presentation/screens/chat/widgets/messages/end_chat_message_widget.dart';
import 'package:zodiac/presentation/screens/chat/widgets/messages/missed_message_widget.dart';
import 'package:zodiac/presentation/screens/chat/widgets/messages/simple_message_widget.dart';
import 'package:zodiac/presentation/screens/chat/widgets/messages/start_chat_message_widget.dart';

class ChatMessageWidget extends StatelessWidget {
  final ChatMessageModel chatMessageModel;

  const ChatMessageWidget({
    Key? key,
    required this.chatMessageModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (chatMessageModel.type) {
      case ChatMessageType.simple:
        return SimpleMessageWidget(
          chatMessageModel: chatMessageModel,
        );
      case ChatMessageType.coupon:
        return CouponMessageWidget(
          chatMessageModel: chatMessageModel,
        );
      case ChatMessageType.review:
        return Text(chatMessageModel.type.name);
      case ChatMessageType.products:
        return Text(chatMessageModel.type.name);
      case ChatMessageType.system:
        return Text(chatMessageModel.type.name);
      case ChatMessageType.private:
        return SimpleMessageWidget(
          chatMessageModel: chatMessageModel,
        );
      case ChatMessageType.tips:
        return Text(chatMessageModel.type.name);
      case ChatMessageType.image:
        return Text(chatMessageModel.type.name);
      case ChatMessageType.startChat:
        return StartChatMessageWidget(
          title: SZodiac.of(context).chatStartedZodiac,
          date: chatMessageModel.utc,
        );
      case ChatMessageType.endChat:
        return EndChatMessageWidget(
          title: SZodiac.of(context).chatEndedZodiac,
          iconPath: Assets.zodiac.chatFee.path,
          date: chatMessageModel.utc,
          isOutgoing: chatMessageModel.isOutgoing,
        );
      case ChatMessageType.startCall:
        return StartChatMessageWidget(
          title: SZodiac.of(context).callStartedZodiac,
          date: chatMessageModel.utc,
        );
      case ChatMessageType.endCall:
        return EndChatMessageWidget(
          title: SZodiac.of(context).callEndedZodiac,
          iconPath: Assets.zodiac.callFee.path,
          date: chatMessageModel.utc,
          isOutgoing: chatMessageModel.isOutgoing,
        );
      case ChatMessageType.advisorMessages:
        return SimpleMessageWidget(
          chatMessageModel: chatMessageModel,
        );
      case ChatMessageType.extend:
        return Text(chatMessageModel.type.name);
      case ChatMessageType.missed:
        return MissedMessageWidget(
          chatMessageModel: chatMessageModel,
        );
      case ChatMessageType.couponAfterSession:
        return Text(chatMessageModel.type.name);
      case ChatMessageType.translated:
        return SimpleMessageWidget(
          chatMessageModel: chatMessageModel,
        );
      case ChatMessageType.productList:
        return Text(chatMessageModel.type.name);
      case ChatMessageType.audio:
        return Text(chatMessageModel.type.name);
    }
  }
}
