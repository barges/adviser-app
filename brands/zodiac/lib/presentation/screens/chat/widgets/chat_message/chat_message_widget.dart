import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:zodiac/data/models/chat/chat_message_model.dart';
import 'package:zodiac/data/models/enums/chat_message_type.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/screens/chat/widgets/messages/coupon_message_widget.dart';
import 'package:zodiac/presentation/screens/chat/widgets/messages/end_chat_message_widget.dart';
import 'package:zodiac/presentation/screens/chat/widgets/messages/image_message_widget.dart';
import 'package:zodiac/presentation/screens/chat/widgets/messages/missed_message_widget.dart';
import 'package:zodiac/presentation/screens/chat/widgets/messages/review_message_widget.dart';
import 'package:zodiac/presentation/screens/chat/widgets/messages/simple_message_widget.dart';
import 'package:zodiac/presentation/screens/chat/widgets/messages/start_chat_message_widget.dart';
import 'package:zodiac/presentation/screens/chat/widgets/messages/system_message_widget.dart';
import 'package:zodiac/presentation/screens/chat/widgets/messages/tips_message_widget.dart';

class ChatMessageWidget extends StatelessWidget {
  final ChatMessageModel chatMessageModel;
  final bool hideLoader;

  const ChatMessageWidget({
    Key? key,
    required this.chatMessageModel,
    this.hideLoader = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (chatMessageModel.type) {
      case ChatMessageType.simple:
        return SimpleMessageWidget(
          chatMessageModel: chatMessageModel,
          hideLoader: hideLoader,
        );
      case ChatMessageType.coupon:
        return CouponMessageWidget(
          chatMessageModel: chatMessageModel,
        );
      case ChatMessageType.review:
        return ReviewMessageWidget(
          chatMessageModel: chatMessageModel,
        );
      case ChatMessageType.products:
        return Text(chatMessageModel.type.name);
      case ChatMessageType.system:
        return SystemMessageWidget(
          chatMessageModel: chatMessageModel,
        );
      case ChatMessageType.private:
        return SimpleMessageWidget(
          chatMessageModel: chatMessageModel,
          hideLoader: hideLoader,
        );
      case ChatMessageType.tips:
        return TipsMessageWidget(chatMessageModel: chatMessageModel);
      case ChatMessageType.image:
        return ImageMessageWidget(
          chatMessageModel: chatMessageModel,
          hideLoader: hideLoader,
        );
      case ChatMessageType.startChat:
        return StartChatMessageWidget(
          title: SZodiac.of(context).chatStartedZodiac,
          date: chatMessageModel.utc,
        );
      case ChatMessageType.endChat:
        return EndChatMessageWidget(
          title: SZodiac.of(context).chatEndedZodiac,
          iconPath: Assets.zodiac.vectors.chatFee.path,
          date: chatMessageModel.utc,
          isOutgoing: chatMessageModel.isOutgoing,
          chatDuration: Duration(seconds: chatMessageModel.timerReal ?? 0),
        );
      case ChatMessageType.startCall:
        return StartChatMessageWidget(
          title: SZodiac.of(context).callStartedZodiac,
          date: chatMessageModel.utc,
        );
      case ChatMessageType.endCall:
        return EndChatMessageWidget(
          title: SZodiac.of(context).callEndedZodiac,
          iconPath: Assets.zodiac.vectors.call.path,
          date: chatMessageModel.utc,
          isOutgoing: chatMessageModel.isOutgoing,
          chatDuration: Duration(seconds: chatMessageModel.timerReal ?? 0),
        );
      case ChatMessageType.advisorMessages:
        return SimpleMessageWidget(
          chatMessageModel: chatMessageModel,
          hideLoader: hideLoader,
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
          hideLoader: hideLoader,
        );
      case ChatMessageType.productList:
        return Text(chatMessageModel.type.name);
      case ChatMessageType.audio:
        return Text(chatMessageModel.type.name);
    }
  }
}
