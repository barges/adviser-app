import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/data/cache/caching_manager.dart';
import 'package:shared_advisor_interface/data/models/chats/chat_item.dart';
import 'package:shared_advisor_interface/data/models/enums/chat_item_status_type.dart';
import 'package:shared_advisor_interface/domain/repositories/chats_repository.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/appbar/chat_conversation_app_bar.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_elevated_button.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/choose_option_widget.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/customer_profile/customer_profile_widget.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/show_delete_alert.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/chat_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_media_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_recorded_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_recording_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_text_input_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_text_media_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_text_widget.dart';
import 'package:shared_advisor_interface/presentation/themes/app_colors.dart';

import 'widgets/chat_info_card.dart';

const _textCounterWidth = 92.0;

class ChatScreen extends StatelessWidget {
  final ChatItem _question = Get.arguments;

  ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatCubit(
        getIt.get<CachingManager>(),
        getIt.get<ChatsRepository>(),
        _question,
        context,
      ),
      child: Builder(
        builder: (context) {
          final ChatCubit chatCubit = context.read<ChatCubit>();

          return Scaffold(
            appBar: ChatConversationAppBar(
              title: _question.clientName ?? '',
              zodiacSign: _question.clientInformation?.zodiac,
            ),
            body: SafeArea(
              child: Builder(builder: (context) {
                final int currentIndex = context
                    .select((ChatCubit cubit) => cubit.state.currentTabIndex);
                return Column(
                  children: [
                    const Divider(
                      height: 1.0,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 16.0,
                      ),
                      color: Theme.of(context).canvasColor,
                      child: ChooseOptionWidget(
                        options: [
                          S.of(context).activeChat,
                          S.of(context).history,
                          S.of(context).profile,
                        ],
                        currentIndex: currentIndex,
                        onChangeOptionIndex: chatCubit.changeCurrentTabIndex,
                      ),
                    ),
                    Expanded(
                      child: IndexedStack(
                        index: currentIndex,
                        children: [
                          const _ActiveChat(),
                          const _HistoryChat(),
                          CustomerProfileWidget(
                            customerId: _question.clientID ?? '',
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ),
          );
        },
      ),
    );
  }
}

class _ActiveChat extends StatelessWidget {
  const _ActiveChat({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ChatCubit chatCubit = context.read<ChatCubit>();
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              Builder(
                builder: (context) {
                  final List<ChatItem> items = context
                      .select((ChatCubit cubit) => cubit.state.activeMessages);

                  return items.isNotEmpty
                      ? Container(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          child: ListView.builder(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            controller:
                                chatCubit.activeMessagesScrollController,
                            itemBuilder: (_, index) {
                              if (index == 0) {
                                final ChatItem question = items[0];
                                return InfoCard(
                                  question: question,
                                );
                              } else {
                                final itemIndex = index - 1;
                                return _ChatItemWidget(items[itemIndex],
                                    onPressedTryAgain: !items[itemIndex].isSent
                                        ? chatCubit.sendAnswerAgain
                                        : null);
                              }
                            },
                            itemCount: items.length + 1,
                          ),
                        )
                      : const SizedBox.shrink();
                },
              ),
              Builder(
                builder: (context) {
                  final ChatItemStatusType? questionStatus = context
                      .select((ChatCubit cubit) => cubit.state.questionStatus);
                  if (questionStatus == ChatItemStatusType.taken) {
                    return const Positioned(
                      bottom: 0.0,
                      right: 0.0,
                      child: _TextCounter(
                        width: _textCounterWidth,
                        height: 22.0,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              Builder(builder: (context) {
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
                        title: S.of(context).takeQuestion,
                        onPressed: chatCubit.takeQuestion,
                      ),
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              }),
            ],
          ),
        ),
        Container(
          color: Theme.of(context).canvasColor,
          child: Stack(
            children: [
              Builder(
                builder: (context) {
                  final bool isRecordingAudio = context.select(
                      (ChatCubit cubit) => cubit.state.isRecordingAudio);
                  final bool isAudioFileSaved = context.select(
                      (ChatCubit cubit) => cubit.state.isAudioFileSaved);
                  final isPlayingRecordedAudio = context.select(
                      (ChatCubit cubit) => cubit.state.isPlayingRecordedAudio);

                  if (isAudioFileSaved) {
                    return ChatRecordedWidget(
                      isPlaying: isPlayingRecordedAudio,
                      playbackStream: chatCubit.state.playbackStream,
                      onStartPlayPressed: () =>
                          chatCubit.startPlayRecordedAudio(),
                      onPausePlayPressed: () => chatCubit.pauseRecordedAudio(),
                      onDeletePressed: () async {
                        final bool? isDelete = await showDeleteAlert(
                            context, S.of(context).doYouWantToDeleteImage);
                        if (isDelete!) {
                          chatCubit.deletedRecordedAudio();
                        }
                      },
                      onSendPressed: () => chatCubit.sendMedia(),
                    );
                  }

                  if (isRecordingAudio) {
                    return ChatRecordingWidget(
                      onClosePressed: () => chatCubit.cancelRecordingAudio(),
                      onStopRecordPressed: () => chatCubit.stopRecordingAudio(),
                      recordingStream: chatCubit.state.recordingStream,
                    );
                  } else {
                    return Builder(
                      builder: (context) {
                        final ChatItemStatusType? questionStatus =
                            context.select((ChatCubit cubit) =>
                                cubit.state.questionStatus);
                        if (questionStatus == ChatItemStatusType.taken) {
                          return const ChatTextInputWidget();
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    );
                  }
                },
              ),
              const Divider(
                height: 1.0,
                endIndent: _textCounterWidth,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HistoryChat extends StatelessWidget {
  const _HistoryChat({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ChatCubit chatCubit = context.read<ChatCubit>();
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              Builder(
                builder: (context) {
                  final List<ChatItem> items = context
                      .select((ChatCubit cubit) => cubit.state.hystoryMessages);
                  return Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      controller: chatCubit.hystoryMessagesScrollController,
                      reverse: true,
                      itemBuilder: (_, index) => _ChatItemWidget(items[index],
                          onPressedTryAgain: !items[index].isSent
                              ? chatCubit.sendAnswerAgain
                              : null),
                      itemCount: items.length,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ChatItemWidget extends StatelessWidget {
  final ChatItem item;
  final VoidCallback? onPressedTryAgain;

  const _ChatItemWidget(
    this.item, {
    Key? key,
    this.onPressedTryAgain,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (item.isMedia) {
      if (item.content != null && item.content!.isNotEmpty) {
        return ChatTextMediaWidget(
          item: item,
          onPressedTryAgain: onPressedTryAgain,
        );
      }

      return ChatMediaWidget(
        item: item,
        onPressedTryAgain: onPressedTryAgain,
      );
    }

    return ChatTextWidget(
      item: item,
      onPressedTryAgain: onPressedTryAgain,
    );
  }
}

class _TextCounter extends StatelessWidget {
  final double width;
  final double height;

  const _TextCounter({
    Key? key,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Builder(builder: (context) {
      final int inputTextLength =
          context.select((ChatCubit cubit) => cubit.state.inputTextLength);
      final isEnabled = inputTextLength >= AppConstants.minTextLength &&
          inputTextLength <= AppConstants.maxTextLength;
      return Stack(
        children: [
          Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: theme.canvasColor,
              borderRadius:
                  const BorderRadius.only(topLeft: Radius.circular(4.0)),
              border: Border(
                top: BorderSide(color: theme.hintColor),
                right: BorderSide(color: theme.hintColor),
                bottom: BorderSide(color: theme.hintColor),
                left: BorderSide(color: theme.hintColor),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                textAlign: TextAlign.center,
                '${AppConstants.maxTextLength}/$inputTextLength',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isEnabled ? AppColors.online : theme.errorColor,
                  fontSize: 12.0,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0.0,
            child: Container(
              color: theme.canvasColor,
              width: width,
              height: 1.0,
            ),
          ),
        ],
      );
    });
  }
}
