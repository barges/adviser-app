import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/data/cache/caching_manager.dart';
import 'package:shared_advisor_interface/data/models/chats/chat_item.dart';
import 'package:shared_advisor_interface/data/models/enums/chat_item_status_type.dart';
import 'package:shared_advisor_interface/data/models/enums/chat_item_type.dart';
import 'package:shared_advisor_interface/domain/repositories/chats_repository.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/appbar/chat_conversation_app_bar.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_elevated_button.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/choose_option_widget.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/customer_profile/customer_profile_widget.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/messages/app_error_widget.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/messages/app_succes_widget.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/ok_cancel_alert.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/show_delete_alert.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/chat_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_media_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_recorded_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_recording_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_text_input_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_text_media_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_text_widget.dart';

import 'widgets/chat_info_card.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatCubit(
        getIt.get<ChatsRepository>(),
        () => showAlert(context),
        context,
      ),
      child: Builder(
        builder: (context) {
          final S s = S.of(context);
          final ChatCubit chatCubit = context.read<ChatCubit>();

          return Builder(builder: (context) {
            final ChatItem? questionFromDB =
                context.select((ChatCubit cubit) => cubit.state.questionFromDB);
            return Scaffold(
              appBar: ChatConversationAppBar(
                  title: questionFromDB?.clientName ?? '',
                  zodiacSign: questionFromDB?.clientInformation?.zodiac,
                  returnInQueueButtonOnTap: () async {
                    final dynamic needReturn = await showOkCancelAlert(
                      context: context,
                      title: s.youRefuseToAnswerThisQuestion,
                      description: s
                          .itWillGoBackIntoTheGeneralQueueAndYouWillNotBeAbleToTakeItAgain,
                      okText: s.ok,
                      actionOnOK: () => Navigator.pop(context, true),
                      allowBarrierClock: false,
                      isCancelEnabled: true,
                    );

                    if (needReturn == true) {
                      await chatCubit.returnQuestion();
                    }
                  }),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                        color: Theme.of(context).canvasColor,
                        padding: const EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 16.0,
                        ),
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
                      Builder(
                        builder: (BuildContext context) {
                          final String message = context.select(
                              (ChatCubit cubit) => cubit.state.successMessage);
                          return message.isNotEmpty
                              ? AppSuccessWidget(
                                  message: message,
                                  onClose: chatCubit.clearSuccessMessage,
                                )
                              : const SizedBox.shrink();
                        },
                      ),
                      Builder(
                        builder: (context) {
                          final String errorMessage = context.select(
                              (ChatCubit cubit) => cubit.state.errorMessage);
                          return errorMessage.isNotEmpty
                              ? AppErrorWidget(
                                  errorMessage: errorMessage,
                                  close: chatCubit.clearErrorMessage,
                                )
                              : const SizedBox.shrink();
                        },
                      ),
                      Expanded(
                        child: IndexedStack(
                          index: currentIndex,
                          children: [
                            const _ActiveChat(),
                            const _HistoryChat(),
                            questionFromDB?.clientID != null
                                ? CustomerProfileWidget(
                                    customerId: questionFromDB!.clientID!,
                                  )
                                : const SizedBox.shrink(),
                          ],
                        ),
                      ),
                    ],
                  );
                }),
              ),
              bottomNavigationBar: Builder(
                builder: (context) {
                  final int currentIndex = context
                      .select((ChatCubit cubit) => cubit.state.currentTabIndex);
                  final ChatItemStatusType? questionStatus = context
                      .select((ChatCubit cubit) => cubit.state.questionStatus);

                  if (currentIndex == 0) {
                    if (chatCubit.chatScreenArguments.publicQuestionId !=
                        null) {
                      final bool showInputFieldIfPublic = context.select(
                          (ChatCubit cubit) =>
                              cubit.state.showInputFieldIfPublic);
                      if (!showInputFieldIfPublic ||
                          questionStatus != ChatItemStatusType.taken) {
                        return const SizedBox.shrink();
                      } else {
                        return Builder(
                          builder: (context) {
                            final bool isRecordingAudio = context.select(
                                (ChatCubit cubit) =>
                                    cubit.state.isRecordingAudio);
                            final bool isAudioFileSaved = context.select(
                                (ChatCubit cubit) =>
                                    cubit.state.isAudioFileSaved);

                            if (isAudioFileSaved) {
                              return ChatRecordedWidget(
                                playbackStream: chatCubit.state.playbackStream,
                                onStartPlayPressed: () =>
                                    chatCubit.startPlayRecordedAudio(),
                                onPausePlayPressed: () =>
                                    chatCubit.pauseRecordedAudio(),
                                onDeletePressed: () async {
                                  if ((await showDeleteAlert(
                                      context,
                                      S
                                          .of(context)
                                          .doYouWantToDeleteAudioMessage))!) {
                                    chatCubit.deletedRecordedAudio();
                                  }
                                },
                                onSendPressed: chatCubit.sendMediaAnswer,
                              );
                            } else if (isRecordingAudio) {
                              return ChatRecordingWidget(
                                onClosePressed: () =>
                                    chatCubit.cancelRecordingAudio(),
                                onStopRecordPressed: () =>
                                    chatCubit.stopRecordingAudio(),
                                recordingStream:
                                    chatCubit.state.recordingStream,
                              );
                            } else {
                              return const ChatTextInputWidget();
                            }
                          },
                        );
                      }
                    } else {
                      if (questionStatus != ChatItemStatusType.answered) {
                        return Builder(
                          builder: (context) {
                            final bool isRecordingAudio = context.select(
                                (ChatCubit cubit) =>
                                    cubit.state.isRecordingAudio);
                            final bool isAudioFileSaved = context.select(
                                (ChatCubit cubit) =>
                                    cubit.state.isAudioFileSaved);

                            if (isAudioFileSaved) {
                              return ChatRecordedWidget(
                                playbackStream: chatCubit.state.playbackStream,
                                onStartPlayPressed: () =>
                                    chatCubit.startPlayRecordedAudio(),
                                onPausePlayPressed: () =>
                                    chatCubit.pauseRecordedAudio(),
                                onDeletePressed: () async {
                                  if ((await showDeleteAlert(
                                      context,
                                      S
                                          .of(context)
                                          .doYouWantToDeleteAudioMessage))!) {
                                    chatCubit.deletedRecordedAudio();
                                  }
                                },
                                onSendPressed: chatCubit.sendMediaAnswer,
                              );
                            } else if (isRecordingAudio) {
                              return ChatRecordingWidget(
                                onClosePressed: () =>
                                    chatCubit.cancelRecordingAudio(),
                                onStopRecordPressed: () =>
                                    chatCubit.stopRecordingAudio(),
                                recordingStream:
                                    chatCubit.state.recordingStream,
                              );
                            } else {
                              return const ChatTextInputWidget();
                            }
                          },
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    }
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            );
          });
        },
      ),
    );
  }

  showAlert(BuildContext context) async {
    await showOkCancelAlert(
      context: context,
      title: getIt.get<MainCubit>().state.errorMessage,
      okText: S.of(context).ok,
      actionOnOK: () {
        Get.close(2);
      },
      allowBarrierClock: false,
      isCancelEnabled: false,
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
    return Stack(
      children: [
        Builder(
          builder: (context) {
            final List<ChatItem> activeMessages =
                context.select((ChatCubit cubit) => cubit.state.activeMessages);

            if (activeMessages.isNotEmpty) {
              return Column(
                children: [
                  Expanded(
                    child: Container(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: ListView.separated(
                        padding:
                            const EdgeInsets.fromLTRB(12.0, 16.0, 12.0, 24.0),
                        reverse:
                            chatCubit.chatScreenArguments.publicQuestionId !=
                                    null
                                ? false
                                : true,
                        shrinkWrap: true,
                        itemBuilder: (_, index) {
                          if (activeMessages.first.type ==
                              ChatItemType.ritual) {
                            if (index < activeMessages.length) {
                              final ChatItem question = activeMessages[index];

                              return _ChatItemWidget(question,
                                  onPressedTryAgain: !question.isSent
                                      ? chatCubit.sendAnswerAgain
                                      : null);
                            } else {
                              return InfoCard(
                                question: chatCubit.state.questionFromDB,
                              );
                            }
                          } else {
                            final ChatItem question = activeMessages[index];

                            return _ChatItemWidget(question,
                                onPressedTryAgain: !question.isSent
                                    ? chatCubit.sendAnswerAgain
                                    : null);
                          }
                        },
                        itemCount:
                            activeMessages.first.type == ChatItemType.ritual
                                ? activeMessages.length + 1
                                : activeMessages.length,
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(
                            height: 8.0,
                          );
                        },
                      ),
                    ),
                  ),
                  if (chatCubit.chatScreenArguments.publicQuestionId != null)
                    Builder(
                      builder: (context) {
                        final ChatItemStatusType? questionStatus =
                            context.select((ChatCubit cubit) =>
                                cubit.state.questionStatus);
                        if (questionStatus == ChatItemStatusType.open) {
                          return const SizedBox(
                            height: 72.0,
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
                ],
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
        if (chatCubit.chatScreenArguments.publicQuestionId != null)
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
                      title: S.of(context).takeQuestion,
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
    return Builder(
      builder: (context) {
        final List<ChatItem> items =
            context.select((ChatCubit cubit) => cubit.state.hystoryMessages);
        return Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 12.0),
            shrinkWrap: true,
            reverse: true,
            itemBuilder: (_, index) => _ChatItemWidget(items[index],
                onPressedTryAgain:
                    !items[index].isSent ? chatCubit.sendAnswerAgain : null),
            itemCount: items.length,
          ),
        );
      },
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
      } else {
        return ChatMediaWidget(
          item: item,
          onPressedTryAgain: onPressedTryAgain,
        );
      }
    } else {
      return ChatTextWidget(
        item: item,
        onPressedTryAgain: onPressedTryAgain,
      );
    }
  }
}
