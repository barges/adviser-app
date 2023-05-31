import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/show_delete_alert.dart';
import 'package:zodiac/data/models/chat/chat_message_model.dart';
import 'package:zodiac/data/models/enums/chat_message_type.dart';
import 'package:zodiac/domain/repositories/zodiac_chat_repository.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/infrastructure/di/inject_config.dart';
import 'package:zodiac/presentation/screens/chat/chat_cubit.dart';
import 'package:zodiac/presentation/screens/chat/widgets/chat_message/chat_message_cubit.dart';
import 'package:zodiac/presentation/screens/chat/widgets/messages/coupon_message_widget.dart';
import 'package:zodiac/presentation/screens/chat/widgets/messages/end_chat_message_widget.dart';
import 'package:zodiac/presentation/screens/chat/widgets/messages/image_message_widget.dart';
import 'package:zodiac/presentation/screens/chat/widgets/messages/missed_message_widget.dart';
import 'package:zodiac/presentation/screens/chat/widgets/messages/review_message_widget.dart';
import 'package:zodiac/presentation/screens/chat/widgets/messages/simple_message_widget.dart';
import 'package:zodiac/presentation/screens/chat/widgets/messages/start_chat_message_widget.dart';
import 'package:zodiac/presentation/screens/chat/widgets/messages/system_message_widget.dart';
import 'package:zodiac/presentation/screens/chat/widgets/messages/tips_message_widget.dart';
import 'package:zodiac/presentation/screens/chat/widgets/resend_message_widget.dart';

import 'package:zodiac/services/websocket_manager/websocket_manager.dart';
import 'package:zodiac/zodiac_main_cubit.dart';

// ignore: must_be_immutable
class ChatMessageWidget extends StatelessWidget {
  ChatMessageModel chatMessageModel;

  ChatMessageWidget({
    Key? key,
    required this.chatMessageModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ChatCubit chatCubit = context.read<ChatCubit>();

    return BlocProvider(
      create: (context) => ChatMessageCubit(
        chatMessageModel,
        chatCubit.enterRoomData?.roomData?.id,
        chatCubit.clientData.id,
        zodiacGetIt.get<WebSocketManager>(),
        zodiacGetIt.get<ZodiacMainCubit>(),
        chatMessageModel.type == ChatMessageType.image,
        zodiacGetIt.get<ZodiacChatRepository>(),
        context,
      ),
      child: Builder(builder: (context) {
        final ChatMessageCubit chatMessageCubit =
            context.read<ChatMessageCubit>();

        final bool showResendWidget = context
            .select((ChatMessageCubit cubit) => cubit.state.showResendWidget);

        final bool updateMessageIdDelivered = context.select(
            (ChatMessageCubit cubit) => cubit.state.updateMessageIsDelivered);
        if (updateMessageIdDelivered) {
          chatMessageModel = chatMessageModel.copyWith(isDelivered: true);
        }

        return Stack(
          children: [
            Column(
              children: [
                Builder(builder: (context) {
                  switch (chatMessageModel.type) {
                    case ChatMessageType.simple:
                      return SimpleMessageWidget(
                        chatMessageModel: chatMessageModel,
                        hideLoader: showResendWidget,
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
                        hideLoader: showResendWidget,
                      );
                    case ChatMessageType.tips:
                      return TipsMessageWidget(
                          chatMessageModel: chatMessageModel);
                    case ChatMessageType.image:
                      return ImageMessageWidget(
                        chatMessageModel: chatMessageModel,
                        hideLoader: showResendWidget,
                      );
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
                        chatDuration:
                            Duration(seconds: chatMessageModel.timerReal ?? 0),
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
                        chatDuration:
                            Duration(seconds: chatMessageModel.timerReal ?? 0),
                      );
                    case ChatMessageType.advisorMessages:
                      return SimpleMessageWidget(
                        chatMessageModel: chatMessageModel,
                        hideLoader: showResendWidget,
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
                        hideLoader: showResendWidget,
                      );
                    case ChatMessageType.productList:
                      return Text(chatMessageModel.type.name);
                    case ChatMessageType.audio:
                      return Text(chatMessageModel.type.name);
                  }
                }),
                if (showResendWidget && chatMessageModel.isOutgoing)
                  const SizedBox(
                    height: 24.0,
                  ),
              ],
            ),
            if (chatMessageModel.isOutgoing && showResendWidget)
              Positioned(
                bottom: 0.0,
                right: 0.0,
                child: ResendMessageWidget(
                  onCancel: () async {
                    final bool? shouldDelete = await showDeleteAlert(
                      context,
                      SZodiac.of(context).doYouWantToDeleteThisMessageZodiac,
                    );
                    if (shouldDelete == true) {
                      chatCubit.deleteMessage(chatMessageModel.mid);
                    }
                  },
                  onTryAgain: () => chatMessageCubit.resendChatMessage(context),
                ),
              ),
          ],
        );
      }),
    );
  }
}
