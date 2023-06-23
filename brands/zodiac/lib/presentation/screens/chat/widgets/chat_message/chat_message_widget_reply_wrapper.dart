import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:zodiac/data/models/chat/chat_message_model.dart';
import 'package:zodiac/presentation/screens/chat/chat_cubit.dart';
import 'package:zodiac/presentation/screens/chat/widgets/chat_message/chat_message_widget.dart';

class ChatMessageWidgetReplyWrapper extends StatefulWidget {
  final ChatMessageModel chatMessageModel;
  final bool chatIsActive;
  final ChatCubit chatCubit;

  const ChatMessageWidgetReplyWrapper({
    Key? key,
    required this.chatMessageModel,
    required this.chatIsActive,
    required this.chatCubit,
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
    final bool canReply =
        widget.chatIsActive && widget.chatMessageModel.supportsReply;
    final int? repliedMessageId = widget.chatCubit.state.repliedMessage?.id;
    final bool isCurrentReplyMessage = repliedMessageId != null &&
        widget.chatMessageModel.id == repliedMessageId;

    return canReply
        ? Dismissible(
            key: isCurrentReplyMessage
                ? widget.chatCubit.repliedMessageGlobalKey
                : ValueKey(widget.chatMessageModel.hashCode),
            direction: DismissDirection.endToStart,
            confirmDismiss: (DismissDirection direction) async {
              widget.chatCubit.setRepliedMessage(
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
    final int? repliedMessageId = widget.chatCubit.state.repliedMessage?.id;
    final bool isCurrentReplyMessage = repliedMessageId != null &&
        widget.chatMessageModel.id == repliedMessageId;
    return isCurrentReplyMessage ? true : false;
  }
}
