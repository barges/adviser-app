import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:zodiac/data/models/chat/chat_message_model.dart';
import 'package:zodiac/presentation/screens/chat/chat_cubit.dart';
import 'package:zodiac/presentation/screens/chat/widgets/audio_players/chat_audio_player_widget.dart';
import 'package:zodiac/presentation/screens/chat/widgets/is_delivered_widget.dart';
import 'package:zodiac/presentation/screens/chat/widgets/messages/reaction_widget.dart';
import 'package:zodiac/zodiac_extensions.dart';

import '../replied_message_content_widget.dart';

class AudioMessageWidget extends StatelessWidget {
  final ChatMessageModel chatMessageModel;
  final bool hideLoader;

  const AudioMessageWidget({
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
                  child: ChatAudioPlayerWidget(
                    isOutgoing: isOutgoing,
                    url: chatMessageModel.path,
                    player: context.read<ChatCubit>().audioPlayer,
                    duration: chatMessageModel.length ?? 0,
                  )),
            ],
          )
        : Row(
            children: [
              _MessageContainer(
                  chatMessageModel: chatMessageModel,
                  hideLoader: hideLoader,
                  child: ChatAudioPlayerWidget(
                    isOutgoing: isOutgoing,
                    url: chatMessageModel.path,
                    player: context.read<ChatCubit>().audioPlayer,
                    duration: chatMessageModel.length ?? 0,
                  )),
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
  final Widget child;

  const _MessageContainer({
    Key? key,
    required this.chatMessageModel,
    required this.hideLoader,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isOutgoing = chatMessageModel.isOutgoing;
    final String date = chatMessageModel.utc?.chatListTime ?? '';

    return Stack(
      children: [
        Container(
          width: 222.0,
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
          decoration: BoxDecoration(
            color: isOutgoing ? theme.primaryColor : theme.canvasColor,
            borderRadius: BorderRadius.circular(
              AppConstants.buttonRadius,
            ),
          ),
          child: Column(
            children: [
              if (chatMessageModel.repliedMessage != null)
                Row(
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
                      width: 12.0,
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
                    )
                  ],
                ),
              child,
            ],
          ),
        ),
        Positioned(
          bottom: 10.0,
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
