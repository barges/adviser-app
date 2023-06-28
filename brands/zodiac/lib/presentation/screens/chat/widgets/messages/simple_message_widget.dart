import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:zodiac/data/models/chat/chat_message_model.dart';
import 'package:zodiac/presentation/screens/chat/widgets/is_delivered_widget.dart';
import 'package:zodiac/presentation/screens/chat/widgets/messages/reaction_widget.dart';
import 'package:zodiac/presentation/screens/chat/widgets/replied_message_content_widget.dart';
import 'package:zodiac/zodiac_constants.dart';
import 'package:zodiac/zodiac_extensions.dart';

class SimpleMessageWidget extends StatelessWidget {
  final ChatMessageModel chatMessageModel;
  final bool hideLoader;

  const SimpleMessageWidget({
    Key? key,
    required this.chatMessageModel,
    this.hideLoader = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isOutgoing = chatMessageModel.isOutgoing;
    return isOutgoing
        ? Row(
            children: [
              Expanded(
                child: ReactionWidget(
                  chatMessageModel: chatMessageModel,
                ),
              ),
              _MessageContainer(
                chatMessageModel: chatMessageModel,
                hideLoader: hideLoader,
              ),
            ],
          )
        : Row(
            children: [
              _MessageContainer(
                chatMessageModel: chatMessageModel,
                hideLoader: hideLoader,
              ),
              Expanded(
                child: ReactionWidget(
                  chatMessageModel: chatMessageModel,
                ),
              ),
            ],
          );
  }
}

class _MessageContainer extends StatelessWidget {
  final ChatMessageModel chatMessageModel;
  final bool hideLoader;

  const _MessageContainer({
    Key? key,
    required this.chatMessageModel,
    required this.hideLoader,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isOutgoing = chatMessageModel.isOutgoing;
    final String date = chatMessageModel.utc?.chatListTime ?? '';

    return Stack(
      children: [
        Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width -
                reactionContainerWidth -
                ZodiacConstants.chatHorizontalPadding * 2,
          ),
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: isOutgoing ? theme.primaryColor : theme.canvasColor,
            borderRadius: BorderRadius.circular(
              AppConstants.buttonRadius,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (chatMessageModel.repliedMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: IntrinsicWidth(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 36.0,
                          width: 2.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2.0),
                            color: isOutgoing
                                ? theme.backgroundColor
                                : theme.primaryColor,
                          ),
                        ),
                        const SizedBox(
                          width: 8.0,
                        ),
                        Expanded(
                          child: RepliedMessageContentWidget(
                            repliedMessage: chatMessageModel.repliedMessage,
                            authorNameColor: isOutgoing
                                ? theme.backgroundColor
                                : theme.primaryColor,
                            messageColor: isOutgoing
                                ? theme.backgroundColor
                                : theme.shadowColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              Text(
                chatMessageModel.message ?? '',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 15.0,
                  color: isOutgoing
                      ? theme.backgroundColor
                      : theme.textTheme.bodySmall?.color,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 4.0,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      date,
                      textAlign: TextAlign.right,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 11.0,
                        color: Colors.transparent,
                      ),
                    ),
                    IsDeliveredWidget(
                      chatMessageModel: chatMessageModel,
                      color: Colors.transparent,
                      hideLoader: hideLoader,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Positioned(
          bottom: 12.0,
          right: 12.0,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                date,
                textAlign: TextAlign.right,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 11.0,
                  color:
                      isOutgoing ? theme.primaryColorLight : theme.shadowColor,
                ),
              ),
              IsDeliveredWidget(
                chatMessageModel: chatMessageModel,
                color: theme.primaryColorLight,
                hideLoader: hideLoader,
              ),
            ],
          ),
        )
      ],
    );
  }
}
