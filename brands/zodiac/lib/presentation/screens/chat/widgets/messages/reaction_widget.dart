import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:zodiac/data/models/chat/chat_message_model.dart';
import 'package:zodiac/presentation/screens/chat/chat_cubit.dart';

const double reactionContainerWidth = 36.0;

class ReactionWidget extends StatelessWidget {
  final ChatMessageModel chatMessageModel;

  const ReactionWidget({
    Key? key,
    required this.chatMessageModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isOutgoing = chatMessageModel.isOutgoing;
    final ChatCubit? chatCubit = context.read<ChatCubit?>();

    return Row(
      mainAxisAlignment:
          isOutgoing ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (chatMessageModel.reaction.isNotEmpty)
          GestureDetector(
            onTap: () {
              final String? id = chatMessageModel.id != null
                  ? chatMessageModel.id.toString()
                  : chatMessageModel.mid;
              if (id != null) {
                chatCubit?.sendReaction(id, '');
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Container(
                width: reactionContainerWidth,
                height: reactionContainerWidth,
                decoration: BoxDecoration(
                  color: isOutgoing ? theme.primaryColor : theme.canvasColor,
                  borderRadius:
                      BorderRadius.circular(AppConstants.buttonRadius),
                ),
                child: Center(
                  child: Text(
                    chatMessageModel.reaction,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
