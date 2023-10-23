import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_size/flutter_keyboard_size.dart';

import '../../../../infrastructure/routing/app_router.dart';
import '../../../data/models/app_error/app_error.dart';
import '../../../data/models/app_error/ui_error_type.dart';
import '../../../data/models/app_success/app_success.dart';
import '../../../data/models/chats/chat_item.dart';
import '../../../data/models/enums/chat_item_status_type.dart';
import '../../../domain/repositories/fortunica_chats_repository.dart';
import '../../../generated/l10n.dart';
import '../../../global.dart';
import '../../../main_cubit.dart';
import '../../../main_state.dart';
import '../../../services/audio/audio_player_service.dart';
import '../../../services/audio/audio_recorder_service.dart';
import '../../../services/check_permission_service.dart';
import '../../../services/connectivity_service.dart';
import '../../../utils/utils.dart';
import '../../common_widgets/appbar/chat_conversation_app_bar.dart';
import '../../common_widgets/buttons/choose_option_widget.dart';
import '../../common_widgets/customer_profile/customer_profile_widget.dart';
import '../../common_widgets/messages/app_error_widget.dart';
import '../../common_widgets/messages/app_success_widget.dart';
import '../../common_widgets/ok_cancel_alert.dart';
import '../../common_widgets/show_delete_alert.dart';
import '../customer_profile/customer_profile_screen.dart';
import 'chat_cubit.dart';
import 'widgets/active_chat_input_field_widget.dart';
import 'widgets/active_chat_widget.dart';
import 'widgets/history/history_widget.dart';

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
        mainCubit: globalGetIt.get<MainCubit>(),
        connectivityService: globalGetIt.get<ConnectivityService>(),
        checkPermissionService: globalGetIt.get<CheckPermissionService>(),
        chatsRepository: globalGetIt.get<FortunicaChatsRepository>(),
        showErrorAlert: () => showErrorAlert(context),
        confirmSendAnswerAlert: () => confirmSendAnswerAlert(context),
        deleteAudioMessageAlert: () => deleteAudioMessageAlert(context),
        recordingIsNotPossibleAlert: () => recordingIsNotPossibleAlert(context),
        chatScreenArguments: chatScreenArguments,
      ),
      child: Builder(builder: (context) {
        return const ChatContentWidget();
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
    final MainCubit mainCubit = context.read<MainCubit>();

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
            mainCubit.updateErrorMessage(
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
                      useRootNavigator: false,
                    );

                    if (needReturn == true) {
                      await chatCubit.returnQuestion();
                    }
                  }),
              backgroundColor: Theme.of(context).canvasColor,
              body: SafeArea(
                child: Builder(builder: (context) {
                  final List<String> tabsTitles = [];
                  if (chatCubit.needActiveChatTab()) {
                    tabsTitles.add(
                      chatCubit.isPublicChat()
                          ? SFortunica.of(context).questionFortunica
                          : SFortunica.of(context).activeChatFortunica,
                    );
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
                              (MainCubit cubit) => cubit.state.appError);

                          return AppErrorWidget(
                            errorMessage: appError.getMessage(context),
                            close: mainCubit.clearErrorMessage,
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
  MainCubit mainCubit = context.read<MainCubit>();
  await showOkCancelAlert(
    context: context,
    title: mainCubit.state.appError.getMessage(context),
    okText: SFortunica.of(context).okFortunica,
    actionOnOK: () {
      mainCubit.updateSessions();
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
  return await showDeleteAlert(context,
      SFortunica.of(context).doYouWantToDeleteThisAudioMessageFortunica);
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
