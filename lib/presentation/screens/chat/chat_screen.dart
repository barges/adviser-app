import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/data/cache/caching_manager.dart';
import 'package:shared_advisor_interface/data/models/app_errors/app_error.dart';
import 'package:shared_advisor_interface/data/models/app_errors/empty_error.dart';
import 'package:shared_advisor_interface/data/models/app_success/app_success.dart';
import 'package:shared_advisor_interface/data/models/app_success/empty_success.dart';
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
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_item_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_recorded_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_recording_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_text_input_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/history/history_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/customer_sessions/customer_sessions_screen.dart';
import 'package:shared_advisor_interface/presentation/themes/app_colors.dart';

import 'widgets/chat_info_card.dart';

const _textCounterWidth = 92.0;

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatCubit(
        getIt.get<CachingManager>(),
        getIt.get<ChatsRepository>(),
        () => showErrorAlert(context),
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
                      Get.back();
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
                      Expanded(
                        child: IndexedStack(
                          index: currentIndex,
                          children: [
                            const _ActiveChat(),
                            questionFromDB?.clientID != null &&
                                    chatCubit.playerMedia != null
                                ? HistoryTab(
                                    clientId: questionFromDB!.clientID!,
                                    playerMedia: chatCubit.playerMedia!,
                                    storyId: chatCubit
                                        .chatScreenArguments.storyIdForHistory,
                                  )
                                : const SizedBox.shrink(),
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
                  final bool isInputField = context
                      .select((ChatCubit cubit) => cubit.state.isInputField);
                  final ChatItemStatusType? questionStatus = context
                      .select((ChatCubit cubit) => cubit.state.questionStatus);

                  if (currentIndex != 0 ||
                      !isInputField ||
                      questionStatus != ChatItemStatusType.taken) {
                    ///TODO: Need investigate!!!
                    return const SizedBox.shrink();
                  } else {
                    return Container(
                      color: Theme.of(context).canvasColor,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Builder(
                            builder: (context) {
                              final bool isRecordingAudio = context.select(
                                  (ChatCubit cubit) =>
                                      cubit.state.isRecordingAudio);
                              final bool isAudioFileSaved = context.select(
                                  (ChatCubit cubit) =>
                                      cubit.state.isAudioFileSaved);
                              final isPlayingRecordedAudio = context.select(
                                  (ChatCubit cubit) =>
                                      cubit.state.isPlayingRecordedAudio);
                              final isSendButtonEnabled = context.select(
                                  (ChatCubit cubit) =>
                                      cubit.state.isSendButtonEnabled);

                              if (isAudioFileSaved) {
                                return ChatRecordedWidget(
                                  isPlaying: isPlayingRecordedAudio,
                                  playbackStream:
                                      chatCubit.state.playbackStream,
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
                                  onSendPressed: isSendButtonEnabled
                                      ? chatCubit.sendMediaAnswer
                                      : null,
                                );
                              }

                              if (isRecordingAudio) {
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
                          ),
                          const Divider(
                            height: 1.0,
                            endIndent: _textCounterWidth,
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            );
          });
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
    allowBarrierClock: false,
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
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (_, index) {
                          if (activeMessages.first.type ==
                              ChatItemType.ritual) {
                            if (index == 0) {
                              return InfoCard(
                                question: activeMessages[0],
                              );
                            } else {
                              final ChatItem question =
                                  activeMessages[index - 1];

                              return ChatItemWidget(question,
                                  onPressedTryAgain: !question.isSent
                                      ? chatCubit.sendAnswerAgain
                                      : null);
                            }
                          } else {
                            final ChatItem question = activeMessages[index];

                            return ChatItemWidget(question,
                                onPressedTryAgain: !question.isSent
                                    ? chatCubit.sendAnswerAgain
                                    : null);
                          }
                        },
                        itemCount:
                            activeMessages.first.type == ChatItemType.ritual
                                ? activeMessages.length + 1
                                : activeMessages.length,
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
        Builder(
          builder: (context) {
            final bool isInputField =
                context.select((ChatCubit cubit) => cubit.state.isInputField);
            final ChatItemStatusType? questionStatus =
                context.select((ChatCubit cubit) => cubit.state.questionStatus);
            if (isInputField && questionStatus == ChatItemStatusType.taken) {
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
        Builder(
          builder: (context) {
            final ChatItemStatusType? questionStatus =
                context.select((ChatCubit cubit) => cubit.state.questionStatus);
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
    final ChatCubit chatCubit = context.read<ChatCubit>();
    final theme = Theme.of(context);
    return Builder(builder: (context) {
      final int inputTextLength =
          context.select((ChatCubit cubit) => cubit.state.inputTextLength);
      final isEnabled =
          context.select((ChatCubit cubit) => cubit.state.isSendButtonEnabled);
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
                '$inputTextLength/${chatCubit.minTextLength}',
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
