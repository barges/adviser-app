import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_size/flutter_keyboard_size.dart';
import 'package:fortunica/data/models/app_errors/app_error.dart';
import 'package:fortunica/data/models/app_errors/ui_error_type.dart';
import 'package:fortunica/data/models/app_success/app_success.dart';
import 'package:fortunica/data/models/chats/chat_item.dart';
import 'package:fortunica/data/models/enums/chat_item_status_type.dart';
import 'package:fortunica/domain/repositories/fortunica_chats_repository.dart';
import 'package:fortunica/fortunica_main_cubit.dart';
import 'package:fortunica/generated/l10n.dart';
import 'package:fortunica/infrastructure/di/inject_config.dart';
import 'package:fortunica/presentation/common_widgets/appbar/chat_conversation_app_bar.dart';
import 'package:fortunica/presentation/common_widgets/buttons/choose_option_widget.dart';
import 'package:fortunica/presentation/common_widgets/customer_profile/customer_profile_widget.dart';
import 'package:fortunica/presentation/common_widgets/messages/app_error_widget.dart';
import 'package:fortunica/presentation/common_widgets/messages/app_success_widget.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/show_delete_alert.dart';
import 'package:fortunica/presentation/screens/chat/chat_cubit.dart';
import 'package:fortunica/presentation/screens/chat/chat_state.dart';
import 'package:fortunica/presentation/screens/chat/widgets/active_chat_input_field_widget.dart';
import 'package:fortunica/presentation/screens/chat/widgets/active_chat_widget.dart';
import 'package:fortunica/presentation/screens/chat/widgets/chat_text_input_widget.dart';
import 'package:fortunica/presentation/screens/chat/widgets/history/history_widget.dart';
import 'package:fortunica/presentation/screens/customer_profile/customer_profile_screen.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/data/models/app_error/app_error.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/main_state.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/ok_cancel_alert.dart';
import 'package:shared_advisor_interface/services/audio/audio_player_service.dart';
import 'package:shared_advisor_interface/services/audio/audio_recorder_service.dart';
import 'package:shared_advisor_interface/services/check_permission_service.dart';
import 'package:shared_advisor_interface/services/connectivity_service.dart';
import 'package:shared_advisor_interface/utils/utils.dart';

class ChatScreen extends StatelessWidget {
  final ChatScreenArguments chatScreenArguments;

  const ChatScreen({
    Key? key,
    required this.chatScreenArguments,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatCubit(
        audioPlayer: AudioPlayerServiceImpl(),
        audioRecorder: AudioRecorderServiceImp(),
        mainCubit: fortunicaGetIt.get<MainCubit>(),
        fortunicaMainCubit: fortunicaGetIt.get<FortunicaMainCubit>(),
        connectivityService: fortunicaGetIt.get<ConnectivityService>(),
        checkPermissionService: fortunicaGetIt.get<CheckPermissionService>(),
        chatsRepository: fortunicaGetIt.get<FortunicaChatsRepository>(),
        showErrorAlert: () => showErrorAlert(context),
        confirmSendAnswerAlert: () => confirmSendAnswerAlert(context),
        deleteAudioMessageAlert: () => deleteAudioMessageAlert(context),
        recordingIsNotPossibleAlert: () => recordingIsNotPossibleAlert(context),
        chatScreenArguments: chatScreenArguments,
      ),
      child: Builder(builder: (context) {
        return BlocListener<ChatCubit, ChatState>(
            listenWhen: (prev, current) =>
                prev.inputTextLength != current.inputTextLength,
            listener: (context, state) {
              final theme = Theme.of(context);
              final ChatCubit chatCubit = context.read<ChatCubit>();
              final double maxWidth = MediaQuery.of(context).size.width -
                  scrollbarThickness -
                  AppConstants.horizontalScreenPadding * 2;
              final TextStyle? style = theme.textTheme.bodySmall?.copyWith(
                color: theme.hoverColor,
                fontSize: 15.0,
                height: 1.2,
              );
              chatCubit.updateHiddenInputHeight(
                Utils.getTextHeight(
                    chatCubit.textInputEditingController.text, style, maxWidth),
                Utils.getTextHeight('\n\n\n\n', style, maxWidth),
              );
            },
            child: const ChatContentWidget());
      }),
    );
  }
}

class ChatContentWidget extends StatelessWidget {
  const ChatContentWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SFortunica s = SFortunica.of(context);
    final ChatCubit chatCubit = context.read<ChatCubit>();
    final FortunicaMainCubit fortunicaMainCubit =
        context.read<FortunicaMainCubit>();

    final ChatItem? questionFromDB =
        context.select((ChatCubit cubit) => cubit.state.questionFromDB);
    final CustomerProfileScreenArguments? appBarUpdateArguments =
        context.select((ChatCubit cubit) => cubit.state.appBarUpdateArguments);
    final ChatItemStatusType? questionStatus =
        context.select((ChatCubit cubit) => cubit.state.questionStatus);

    return WillPopScope(
      onWillPop: () => Future.value(
          !(chatCubit.chatScreenArguments.publicQuestionId != null &&
              questionStatus == ChatItemStatusType.taken)),
      child: BlocListener<MainCubit, MainState>(
        listenWhen: (prev, current) =>
            prev.internetConnectionIsAvailable !=
            current.internetConnectionIsAvailable,
        listener: (_, state) {
          if (!state.internetConnectionIsAvailable) {
            fortunicaMainCubit.updateErrorMessage(
                UIError(uiErrorType: UIErrorType.checkYourInternetConnection));
          }
        },
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Scaffold(
              appBar: ChatConversationAppBar(
                  title: appBarUpdateArguments?.clientName,
                  zodiacSign: appBarUpdateArguments?.zodiacSign ??
                      questionFromDB?.clientInformation?.zodiac,
                  publicQuestionId:
                      chatCubit.chatScreenArguments.publicQuestionId,
                  returnInQueueButtonOnTap: () async {



                    final dynamic needReturn = await showOkCancelAlert(
                      context: context,
                      title: s.doYouWantToRejectThisQuestionFortunica,
                      description: s.itWillGoBackIntoTheGeneralQueueFortunica,
                      okText: s.returnFortunica,
                      allowBarrierClick: false,
                      isCancelEnabled: true,
                    );

                    logger.d(needReturn);

                    if (needReturn == true) {
                      await chatCubit.returnQuestion();
                    }
                  }),
              backgroundColor: Theme.of(context).canvasColor,
              body: SafeArea(
                child: Builder(builder: (context) {
                  final List<String> tabsTitles = [];
                  if (chatCubit.needActiveChatTab()) {
                    tabsTitles.add(chatCubit.isPublicChat()
                        ? SFortunica.of(context).questionFortunica
                        : SFortunica.of(context).activeChatFortunica,);
                  }
                  tabsTitles.addAll([
                    SFortunica.of(context).historyFortunica,
                    SFortunica.of(context).profileFortunica,
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
                      const Divider(
                        height: 1.0,
                      ),
                      Builder(
                        builder: (BuildContext context) {
                          final AppSuccess appSuccess = context.select(
                              (ChatCubit cubit) => cubit.state.appSuccess);
                          return AppSuccessWidget(
                            message: appSuccess.getMessage(context),
                            onClose: chatCubit.clearSuccessMessage,
                          );
                        },
                      ),
                      Builder(
                        builder: (context) {
                          final AppError appError = context.select(
                              (FortunicaMainCubit cubit) => cubit.state.appError);

                          return AppErrorWidget(
                            errorMessage: appError.getMessage(context),
                            close: fortunicaMainCubit.clearErrorMessage,
                          );
                        },
                      ),
                      Builder(builder: (context) {
                        final List<Widget> tabs = [];
                        if (chatCubit.needActiveChatTab()) {
                          tabs.add(const ActiveChatWidget());
                        }
                        tabs.addAll([
                          Builder(builder: (context) {
                            return questionFromDB?.clientID != null
                                ? HistoryWidget(
                                    clientId: questionFromDB!.clientID!,
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
                                  chatCubit: chatCubit,
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
            ),
            KeyboardSizeProvider(
              child: Builder(builder: (context) {
                final bool needBarrierColor = context.select(
                    (ChatCubit cubit) => cubit.state.isStretchedTextField);
                return SafeArea(
                  child: Material(
                    type: needBarrierColor
                        ? MaterialType.canvas
                        : MaterialType.transparency,
                    color: needBarrierColor
                        ? Utils.getOverlayColor(context)
                        : Colors.transparent,
                    child: Builder(
                      builder: (context) {
                        final int currentIndex = context.select(
                            (ChatCubit cubit) => cubit.state.currentTabIndex);
                        final ChatItemStatusType? questionStatus =
                            context.select((ChatCubit cubit) =>
                                cubit.state.questionStatus);

                        if (chatCubit.needActiveChatTab() &&
                            currentIndex == 0) {
                          if (chatCubit.isPublicChat()) {
                            final bool showInputFieldIfPublic = context.select(
                                (ChatCubit cubit) =>
                                    cubit.state.showInputFieldIfPublic);
                            if (!showInputFieldIfPublic ||
                                questionStatus != ChatItemStatusType.taken) {
                              return const SizedBox.shrink();
                            } else {
                              return const ActiveChatInputFieldWidget();
                            }
                          } else {
                            if (questionStatus != ChatItemStatusType.answered) {
                              return const ActiveChatInputFieldWidget();
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
              }),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> showErrorAlert(BuildContext context) async {
  FortunicaMainCubit fortunicaMainCubit = context.read<FortunicaMainCubit>();
  await showOkCancelAlert(
    context: context,
    title: fortunicaMainCubit.state.appError.getMessage(context),
    okText: SFortunica.of(context).okFortunica,
    actionOnOK: () {
      fortunicaMainCubit.updateSessions();
      context.pop();
    },
    allowBarrierClick: false,
    isCancelEnabled: false,
  );
}

Future<bool?> confirmSendAnswerAlert(BuildContext context) async {
  final s = SFortunica.of(context);
  return await showOkCancelAlert(
    context: context,
    title: s.pleaseConfirmThatYourAnswerIsReadyToBeSentFortunica,
    okText: s.confirmFortunica,
    allowBarrierClick: false,
    isCancelEnabled: true,
  );
}

Future<bool?> deleteAudioMessageAlert(BuildContext context) async {
  return await showDeleteAlert(
      context, SFortunica.of(context).doYouWantToDeleteThisAudioMessageFortunica);
}

Future<bool?> recordingIsNotPossibleAlert(BuildContext context) async {
  final s = SFortunica.of(context);
  return await showOkCancelAlert(
    context: context,
    title: s.recordingIsNotPossibleAllocateSpaceOnTheDeviceFortunica,
    okText: s.okFortunica,
    allowBarrierClick: true,
    isCancelEnabled: false,
  );
}

class ChatScreenArguments {
  final String? clientIdFromPush;
  final ChatItem? question;
  final String? publicQuestionId;
  final String? privateQuestionId;
  final String? ritualID;
  final String? storyIdForHistory;

  ChatScreenArguments({
    this.clientIdFromPush,
    this.question,
    this.publicQuestionId,
    this.privateQuestionId,
    this.ritualID,
    this.storyIdForHistory,
  });
}
