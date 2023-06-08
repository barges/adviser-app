import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:zodiac/data/models/chat/chat_message_model.dart';
import 'package:zodiac/presentation/screens/chat/chat_cubit.dart';
import 'package:zodiac/presentation/screens/chat/widgets/chat_message/chat_message_widget.dart';

class ChatMessageWidgetReplyWrapper extends StatelessWidget {
  final ChatMessageModel chatMessageModel;
  final bool chatIsActive;

  const ChatMessageWidgetReplyWrapper({
    Key? key,
    required this.chatMessageModel,
    required this.chatIsActive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ChatCubit chatCubit = context.read<ChatCubit>();
    final bool canReply = chatIsActive &&
        chatMessageModel.supportsReply;
    final theme = Theme.of(context);
    return canReply
        ? Dismissible(
            key: ValueKey(chatMessageModel.hashCode),
            direction: DismissDirection.endToStart,
            confirmDismiss: (DismissDirection direction) async {
              chatCubit.setRepliedMessage(chatMessageModel);
              return false;
            },
            background: Align(
              alignment: Alignment.centerRight,
              child: Assets.zodiac.vectors.arrowReply.svg(
                height: AppConstants.iconSize,
                width: AppConstants.iconSize,
                colorFilter: ColorFilter.mode(
                  theme.primaryColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
            child: ChatMessageWidget(
              chatMessageModel: chatMessageModel,
            ),
          )
        : ChatMessageWidget(
            chatMessageModel: chatMessageModel,
          );
  }
}
