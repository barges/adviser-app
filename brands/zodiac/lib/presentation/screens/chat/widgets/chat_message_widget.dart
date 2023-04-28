import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:zodiac/data/models/chat/chat_message_model.dart';
import 'package:zodiac/data/models/enums/chat_message_type.dart';
import 'package:zodiac/presentation/common_widgets/app_image_widget.dart';
import 'package:zodiac/presentation/screens/chat/widgets/missed_message_widget.dart';
import 'package:zodiac/zodiac_constants.dart';
import 'package:zodiac/zodiac_extensions.dart';

const double _reactionContainerWidth = 36.0;

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
        return _SimpleMessageWidget(
          chatMessageModel: chatMessageModel,
        );
      case ChatMessageType.coupon:
        return AspectRatio(
          aspectRatio: 8 / 3,
          child: AppImageWidget(
            uri: Uri.parse(chatMessageModel.image ?? ''),
            fit: BoxFit.fill,
          ),
        );
      case ChatMessageType.review:
        return Text(chatMessageModel.type.name);
      case ChatMessageType.products:
        return Text(chatMessageModel.type.name);
      case ChatMessageType.system:
        return Text(chatMessageModel.type.name);
      case ChatMessageType.private:
        return _SimpleMessageWidget(
          chatMessageModel: chatMessageModel,
        );
      case ChatMessageType.tips:
        return Text(chatMessageModel.type.name);
      case ChatMessageType.image:
        return Text(chatMessageModel.type.name);
      case ChatMessageType.startChat:
        return Text(chatMessageModel.type.name);
      case ChatMessageType.endChat:
        return Text(chatMessageModel.type.name);
      case ChatMessageType.startCall:
        return Text(chatMessageModel.type.name);
      case ChatMessageType.endCall:
        return Text(chatMessageModel.type.name);
      case ChatMessageType.advisorMessages:
        return _SimpleMessageWidget(
          chatMessageModel: chatMessageModel,
        );
      case ChatMessageType.extend:
        return Text(chatMessageModel.type.name);
      case ChatMessageType.missed:
        return MissedMessageWidget(chatMessageModel: chatMessageModel);
      case ChatMessageType.couponAfterSession:
        return Text(chatMessageModel.type.name);
      case ChatMessageType.translated:
        return _SimpleMessageWidget(
          chatMessageModel: chatMessageModel,
        );
      case ChatMessageType.productList:
        return Text(chatMessageModel.type.name);
      case ChatMessageType.audio:
        return Text(chatMessageModel.type.name);
    }
  }
}

class _SimpleMessageWidget extends StatelessWidget {
  final ChatMessageModel chatMessageModel;

  const _SimpleMessageWidget({
    Key? key,
    required this.chatMessageModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isOutgoing = chatMessageModel.isOutgoing;
    return Align(
      alignment: isOutgoing ? Alignment.centerRight : Alignment.centerLeft,
      child: isOutgoing
          ? Row(
              children: [
                Expanded(
                  child: _ReactionContainer(
                    chatMessageModel: chatMessageModel,
                  ),
                ),
                _MessageContainer(
                  chatMessageModel: chatMessageModel,
                ),
              ],
            )
          : Row(
              children: [
                _MessageContainer(
                  chatMessageModel: chatMessageModel,
                ),
                Expanded(
                  child: _ReactionContainer(
                    chatMessageModel: chatMessageModel,
                  ),
                ),
              ],
            ),
    );
  }
}

class _MessageContainer extends StatelessWidget {
  final ChatMessageModel chatMessageModel;

  const _MessageContainer({
    Key? key,
    required this.chatMessageModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isOutgoing = chatMessageModel.isOutgoing;
    final String date = DateTime.fromMillisecondsSinceEpoch(
      (chatMessageModel.utc ?? 0) * 1000,
      isUtc: true,
    ).chatListTime;

    return Stack(
      children: [
        Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width -
                _reactionContainerWidth -
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
                  bottom: 2.0,
                ),
                child: Text(
                  date,
                  textAlign: TextAlign.right,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 11.0,
                    color: Colors.transparent,
                  ),
                ),
              )
            ],
          ),
        ),
        Positioned(
          bottom: 14.0,
          right: 12.0,
          child: Text(
            date,
            textAlign: TextAlign.right,
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 11.0,
              color: isOutgoing ? theme.primaryColorLight : theme.shadowColor,
            ),
          ),
        )
      ],
    );
  }
}

class _ReactionContainer extends StatelessWidget {
  final ChatMessageModel chatMessageModel;

  const _ReactionContainer({
    Key? key,
    required this.chatMessageModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isOutgoing = chatMessageModel.isOutgoing;

    return Row(
      mainAxisAlignment:
          isOutgoing ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: const [
        SizedBox(
          width: _reactionContainerWidth,
          height: _reactionContainerWidth,
        ),
      ],
    );
  }
}
