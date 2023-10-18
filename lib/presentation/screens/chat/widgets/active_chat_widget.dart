import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app_constants.dart';
import '../../../../data/models/chats/chat_item.dart';
import '../../../../data/models/enums/chat_item_status_type.dart';
import '../../../../generated/l10n.dart';
import '../../../common_widgets/buttons/app_elevated_button.dart';
import '../chat_cubit.dart';
import 'active_chat_messages_widget.dart';

class ActiveChatWidget extends StatelessWidget {
  const ActiveChatWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ChatCubit chatCubit = context.read<ChatCubit>();
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Stack(
        children: [
          Builder(
            builder: (context) {
              final List<ChatItem> activeMessages = context
                  .select((ChatCubit cubit) => cubit.state.activeMessages);

              if (activeMessages.isNotEmpty) {
                return ActiveChatMessagesWidget(
                  activeMessages: activeMessages,
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
          if (chatCubit.isPublicChat())
            Builder(
              builder: (context) {
                final ChatItemStatusType? questionStatus = context
                    .select((ChatCubit cubit) => cubit.state.questionStatus);
                if (questionStatus == ChatItemStatusType.open) {
                  return Positioned(
                    right: AppConstants.horizontalScreenPadding,
                    bottom: 24.0,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width -
                          AppConstants.horizontalScreenPadding * 2,
                      child: AppElevatedButton(
                        title: SFortunica.of(context).takeQuestionFortunica,
                        onPressed: chatCubit.takeQuestion,
                      ),
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
        ],
      ),
    );
  }
}
