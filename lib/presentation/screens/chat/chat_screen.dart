import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/data/models/app_errors/app_error.dart';
import 'package:shared_advisor_interface/data/models/app_errors/empty_error.dart';
import 'package:shared_advisor_interface/data/models/app_success/app_success.dart';
import 'package:shared_advisor_interface/data/models/app_success/empty_success.dart';
import 'package:shared_advisor_interface/data/models/chats/chat_item.dart';
import 'package:shared_advisor_interface/data/models/chats/rirual_card_info.dart';
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
import 'package:shared_advisor_interface/presentation/resources/app_arguments.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/chat_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_item_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_recorded_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_recording_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_text_input_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/history/history_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/customer_sessions/customer_sessions_screen.dart';

import 'widgets/ritual_info_card_widget.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  Future<void> _sendMediaAnswer(
      BuildContext context, ChatCubit chatCubit) async {
    final s = S.of(context);
    final dynamic isConfirmed = await showOkCancelAlert(
      context: context,
      title: s.pleaseConfirmThatYourAnswerIsReadyToBeSent,
      okText: s.confirm,
      actionOnOK: () => Navigator.pop(context, true),
      allowBarrierClick: false,
      isCancelEnabled: true,
    );

    if (isConfirmed == true) {
      chatCubit.sendMediaAnswer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatCubit(
        getIt.get<ChatsRepository>(),
        () => showErrorAlert(context),
      ),
      child: Builder(
        builder: (context) {
          final S s = S.of(context);
          final ChatCubit chatCubit = context.read<ChatCubit>();

          final ChatItem? questionFromDB =
              context.select((ChatCubit cubit) => cubit.state.questionFromDB);
          final AppBarUpdateArguments? appBarUpdateArguments = context
              .select((ChatCubit cubit) => cubit.state.appBarUpdateArguments);

          return Scaffold(
            body: Scaffold(
              appBar: ChatConversationAppBar(
                  title: appBarUpdateArguments?.clientName ??
                      questionFromDB?.clientName ??
                      '',
                  zodiacSign: appBarUpdateArguments?.zodiacSign ??
                      questionFromDB?.clientInformation?.zodiac,
                  publicQuestionId:
                      chatCubit.chatScreenArguments.publicQuestionId,
                  returnInQueueButtonOnTap: () async {
                    final dynamic needReturn = await showOkCancelAlert(
                      context: context,
                      title: s.doYouWantToRejectThisQuestion,
                      description: s
                          .itWillGoBackIntoTheGeneralQueueYouWillNotBeAbleToTakeItAgain,
                      okText: s.return_,
                      actionOnOK: () => Navigator.pop(context, true),
                      allowBarrierClick: false,
                      isCancelEnabled: true,
                    );

                    if (needReturn == true) {
                      await chatCubit.returnQuestion();
                    }
                  }),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              body: SafeArea(
                child: Builder(builder: (context) {
                  final List<String> tabsTitles = [];
                  if (chatCubit.chatScreenArguments.storyIdForHistory == null) {
                    tabsTitles.add(
                        chatCubit.chatScreenArguments.publicQuestionId != null
                            ? S.of(context).question
                            : S.of(context).activeChat);
                  }
                  tabsTitles.addAll([
                    S.of(context).history,
                    S.of(context).profile,
                  ]);

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
                        child: Builder(builder: (context) {
                          final int currentIndex = context.select(
                              (ChatCubit cubit) => cubit.state.currentTabIndex);
                          return ChooseOptionWidget(
                            options: tabsTitles,
                            currentIndex: currentIndex,
                            onChangeOptionIndex:
                                chatCubit.changeCurrentTabIndex,
                          );
                        }),
                      ),
                      Builder(
                        builder: (BuildContext context) {
                          final AppSuccess appSuccess = context.select(
                              (ChatCubit cubit) => cubit.state.appSuccess);
                          return appSuccess is! EmptySuccess
                              ? AppSuccessWidget(
                                  message: appSuccess.getMessage(context),
                                  onClose: chatCubit.clearSuccessMessage,
                                )
                              : const SizedBox.shrink();
                        },
                      ),
                      Builder(
                        builder: (context) {
                          final AppError appError = context.select(
                              (ChatCubit cubit) => cubit.state.appError);
                          return appError is! EmptyError
                              ? AppErrorWidget(
                                  errorMessage: appError.getMessage(context),
                                  close: chatCubit.clearErrorMessage,
                                )
                              : const SizedBox.shrink();
                        },
                      ),
                      Builder(builder: (context) {
                        final List<Widget> tabs = [];
                        if (chatCubit.chatScreenArguments.storyIdForHistory ==
                            null) {
                          tabs.add(const _ActiveChat());
                        }
                        tabs.addAll([
                          Builder(builder: (context) {
                            final FlutterSoundPlayer? flutterSoundPlayer =
                                context.select((ChatCubit cubit) =>
                                    cubit.state.flutterSoundPlayer);

                            return questionFromDB?.clientID != null &&
                                    flutterSoundPlayer != null
                                ? HistoryWidget(
                                    clientId: questionFromDB!.clientID!,
                                    playerMedia: chatCubit.playerMedia!,
                                    storyId: chatCubit
                                        .chatScreenArguments.storyIdForHistory,
                                  )
                                : const SizedBox.shrink();
                          }),
                          questionFromDB?.clientID != null
                              ? CustomerProfileWidget(
                                  customerId: questionFromDB!.clientID!,
                                  updateClientInformationCallback:
                                      chatCubit.updateAppBarInformation,
                                )
                              : const SizedBox.shrink(),
                        ]);

                        return Builder(builder: (context) {
                          final int currentIndex = context.select(
                              (ChatCubit cubit) => cubit.state.currentTabIndex);
                          return Expanded(
                            child: IndexedStack(
                              index: currentIndex,
                              children: tabs,
                            ),
                          );
                        });
                      }),
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

                  if (chatCubit.chatScreenArguments.storyIdForHistory == null &&
                      currentIndex == 0) {
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
                                onStartPlayPressed: () =>
                                    chatCubit.startPlayRecordedAudio(),
                                onPausePlayPressed: () =>
                                    chatCubit.pauseRecordedAudio(),
                                onDeletePressed: () async {
                                  if ((await showDeleteAlert(
                                      context,
                                      S
                                          .of(context)
                                          .doYouWantToDeleteThisAudioMessage))!) {
                                    chatCubit.deletedRecordedAudio();
                                  }
                                },
                                onSendPressed: () =>
                                    _sendMediaAnswer(context, chatCubit),
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
                                onStartPlayPressed: () =>
                                    chatCubit.startPlayRecordedAudio(),
                                onPausePlayPressed: () =>
                                    chatCubit.pauseRecordedAudio(),
                                onDeletePressed: () async {
                                  if ((await showDeleteAlert(
                                      context,
                                      S
                                          .of(context)
                                          .doYouWantToDeleteThisAudioMessage))!) {
                                    chatCubit.deletedRecordedAudio();
                                  }
                                },
                                onSendPressed: () =>
                                    _sendMediaAnswer(context, chatCubit),
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
            ),
          );
        },
      ),
    );
  }
}

showAlert(BuildContext context) async {
  await showOkCancelAlert(
    context: context,
    title: getIt.get<MainCubit>().state.appError.getMessage(context),
    okText: S.of(context).ok,
    actionOnOK: () {
      Get.close(2);
    },
    allowBarrierClick: false,
    isCancelEnabled: false,
  );
}

class _ActiveChat extends StatelessWidget {
  const _ActiveChat({
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
              final RitualCardInfo? ritualCardInfo = context
                  .select((ChatCubit cubit) => cubit.state.ritualCardInfo);

              if (activeMessages.isNotEmpty) {
                return Column(
                  children: [
                    Expanded(
                      child: Container(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: SingleChildScrollView(
                          controller: chatCubit.activeMessagesScrollController,
                          padding:
                              const EdgeInsets.fromLTRB(12.0, 16.0, 12.0, 24.0),
                          child: Builder(builder: (context) {
                            final List<Widget> widgets = [];

                            if (activeMessages.last.type ==
                                    ChatItemType.ritual &&
                                ritualCardInfo != null) {
                              widgets.add(
                                Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: 16.0,
                                  ),
                                  child: RitualInfoCardWidget(
                                    ritualCardInfo: ritualCardInfo,
                                  ),
                                ),
                              );
                            }

                            for (int i = 0; i < activeMessages.length; i++) {
                              final ChatItem item = activeMessages[i];
                              widgets.add(
                                ChatItemWidget(
                                    key: i == activeMessages.length - 1
                                        ? chatCubit.questionGlobalKey
                                        : null,
                                    item,
                                    onPressedTryAgain: !item.isSent
                                        ? chatCubit.sendAnswerAgain
                                        : null),
                              );
                              if (i < activeMessages.length - 1) {
                                widgets.add(
                                  const SizedBox(
                                    height: 8.0,
                                  ),
                                );
                              }
                            }

                            return Column(
                              children: widgets,
                            );
                          }),
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
      ),
    );
  }
}
