import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/show_delete_alert.dart';
import 'package:zodiac/data/models/chat/chat_message_model.dart';
import 'package:zodiac/data/models/enums/chat_message_type.dart';
import 'package:zodiac/domain/repositories/zodiac_chat_repository.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/infrastructure/di/inject_config.dart';
import 'package:zodiac/presentation/screens/chat/chat_cubit.dart';
import 'package:zodiac/presentation/screens/chat/widgets/chat_message/chat_message_widget.dart';
import 'package:zodiac/presentation/screens/chat/widgets/resend_message_widget.dart';
import 'package:zodiac/presentation/screens/chat/widgets/wrappers/resend_message/resend_message_cubit.dart';
import 'package:zodiac/services/websocket_manager/websocket_manager.dart';
import 'package:zodiac/zodiac_main_cubit.dart';

class ResendMessageWrapper extends StatelessWidget {
  final ChatMessageModel chatMessageModel;
  const ResendMessageWrapper({
    Key? key,
    required this.chatMessageModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ChatCubit chatCubit = context.read<ChatCubit>();

    return BlocProvider(
      create: (context) => ResendMessageCubit(
        chatMessageModel,
        chatCubit.enterRoomData?.roomData?.id,
        chatCubit.clientData.id,
        zodiacGetIt.get<WebSocketManager>(),
        zodiacGetIt.get<ZodiacMainCubit>(),
        chatMessageModel.type == ChatMessageType.image,
        chatMessageModel.type == ChatMessageType.audio,
        zodiacGetIt.get<ZodiacChatRepository>(),
        chatCubit.deleteMessage,
        chatCubit.updateMediaIsDelivered,
        context,
      ),
      child: Builder(builder: (context) {
        final ResendMessageCubit resendMessageCubit =
            context.read<ResendMessageCubit>();
        final bool showResendWidget = context
            .select((ResendMessageCubit cubit) => cubit.state.showResendWidget);

        return Stack(children: [
          Column(
            children: [
              ChatMessageWidget(
                chatMessageModel: chatMessageModel,
              ),
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
                onTryAgain: () => resendMessageCubit.resendChatMessage(context),
              ),
            ),
        ]);
      }),
    );
  }
}
