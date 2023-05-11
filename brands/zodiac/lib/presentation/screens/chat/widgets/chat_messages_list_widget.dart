import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollview_observer/scrollview_observer.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:zodiac/data/models/chat/chat_message_model.dart';
import 'package:zodiac/presentation/screens/chat/chat_cubit.dart';
import 'package:zodiac/presentation/screens/chat/widgets/chat_message_widget.dart';
import 'package:zodiac/presentation/screens/chat/widgets/down_button_widget.dart';
import 'package:zodiac/presentation/screens/chat/widgets/typing_indicator.dart';
import 'package:zodiac/zodiac_constants.dart';

class ChatMessagesListWidget extends StatelessWidget {
  const ChatMessagesListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ChatCubit chatCubit = context.read<ChatCubit>();

    final List<ChatMessageModel> messages =
    context.select(
            (ChatCubit cubit) => cubit.state.messages);

    // for (var element in messages) {
    //   logger.d(element);
    // }

    final int unreadCount = messages
        .where((element) =>
    !element.isOutgoing && !element.isRead)
        .length;

    final bool needShowTypingIndicator = context.select(
            (ChatCubit cubit) =>
        cubit.state.needShowTypingIndicator);

    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: ListViewObserver(
          controller: chatCubit.observerController,
          child: Stack(
            fit: StackFit.expand,
            children: [
              ListView.separated(
                physics: ChatObserverClampingScrollPhysics(
                  observer: chatCubit.chatObserver,
                ),
                shrinkWrap:
                chatCubit.chatObserver.isShrinkWrap,
                controller:
                chatCubit.messagesScrollController,
                padding: const EdgeInsets.all(
                  ZodiacConstants.chatHorizontalPadding,
                ),
                reverse: true,
                itemCount: messages.length,
                itemBuilder:
                    (BuildContext context, int index) {
                  if (index == 0) {
                    return Builder(builder: (context) {
                      return needShowTypingIndicator
                          ? const Align(
                        alignment:
                        Alignment.bottomLeft,
                        child: TypingIndicator(),
                      )
                          : const SizedBox.shrink();
                    });
                  } else {
                    final ChatMessageModel messageModel =
                    messages[index - 1];
                    if (messageModel.isOutgoing ||
                        messageModel.isRead) {
                      return ChatMessageWidget(
                        chatMessageModel: messageModel,
                      );
                    } else {
                      return VisibilityDetector(
                        key:
                        Key(messageModel.id.toString()),
                        onVisibilityChanged:
                            (visibilityInfo) {
                          if (visibilityInfo
                              .visibleFraction ==
                              1) {
                            chatCubit.sendReadMessage(
                                messageModel.id);
                          }
                        },
                        child: ChatMessageWidget(
                          chatMessageModel: messageModel,
                        ),
                      );
                    }
                  }
                },
                separatorBuilder:
                    (BuildContext context, int index) {
                  return const SizedBox(
                    height: 4.0,
                  );
                },
              ),
              Builder(builder: (context) {
                final bool needShowDownButton =
                context.select((ChatCubit cubit) =>
                cubit.state.needShowDownButton);
                return needShowDownButton
                    ? Positioned(
                  right: ZodiacConstants
                      .chatHorizontalPadding,
                  bottom: ZodiacConstants
                      .chatHorizontalPadding,
                  child: DownButtonWidget(
                    unreadCount: unreadCount,
                  ),
                )
                    : const SizedBox.shrink();
              }),
            ],
          ),
        ),
      ),
    );
  }
}
