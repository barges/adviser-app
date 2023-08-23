import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:zodiac/data/models/chat/chat_message_model.dart';
import 'package:zodiac/data/models/enums/chat_message_type.dart';
import 'package:zodiac/presentation/screens/chat/chat_cubit.dart';
import 'package:zodiac/presentation/screens/chat/widgets/chat_message/chat_message_widget.dart';

class ChatMessageWidgetReplyWrapper extends StatefulWidget {
  final ChatMessageModel chatMessageModel;
  final bool chatIsActive;

  const ChatMessageWidgetReplyWrapper({
    Key? key,
    required this.chatMessageModel,
    required this.chatIsActive,
  }) : super(key: key);

  @override
  State<ChatMessageWidgetReplyWrapper> createState() =>
      _ChatMessageWidgetReplyWrapperState();
}

class _ChatMessageWidgetReplyWrapperState
    extends State<ChatMessageWidgetReplyWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);
    final ChatCubit chatCubit = context.read<ChatCubit>();
    final bool canReply = widget.chatIsActive &&
        widget.chatMessageModel.type == ChatMessageType.simple &&
        widget.chatMessageModel.supportsReply;
    final int? repliedMessageId = chatCubit.state.repliedMessage?.id;
    final bool isCurrentReplyMessage = repliedMessageId != null &&
        widget.chatMessageModel.id == repliedMessageId;

    return canReply
        ? Dismissible(
            key: isCurrentReplyMessage &&
                    chatCubit.repliedMessageGlobalKey != null
                ? chatCubit.repliedMessageGlobalKey!
                : ValueKey(widget.chatMessageModel.hashCode),
            direction: DismissDirection.endToStart,
            confirmDismiss: (DismissDirection direction) async {
              chatCubit.setRepliedMessage(
                repliedMessage: widget.chatMessageModel,
              );
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
              chatMessageModel: widget.chatMessageModel,
            ),
          )
        : ChatMessageWidget(
            chatMessageModel: widget.chatMessageModel,
          );
  }

  @override
  bool get wantKeepAlive {
    final int? repliedMessageId =
        context.read<ChatCubit>().state.repliedMessage?.id;
    final bool isCurrentReplyMessage = repliedMessageId != null &&
        widget.chatMessageModel.id == repliedMessageId;
    return isCurrentReplyMessage ? true : false;
  }
}
