import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/data/models/app_errors/app_error.dart';
import 'package:shared_advisor_interface/data/models/app_errors/ui_error_type.dart';
import 'package:shared_advisor_interface/data/models/app_success/app_success.dart';
import 'package:shared_advisor_interface/data/models/chats/chat_item.dart';
import 'package:shared_advisor_interface/data/models/enums/chat_item_status_type.dart';
import 'package:shared_advisor_interface/domain/repositories/chats_repository.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/main_state.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/appbar/chat_conversation_app_bar.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/choose_option_widget.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/customer_profile/customer_profile_widget.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/messages/app_error_widget.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/messages/app_success_widget.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/ok_cancel_alert.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/show_delete_alert.dart';
import 'package:shared_advisor_interface/presentation/resources/app_arguments.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/chat_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/active_chat_input_field_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/active_chat_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/history/history_widget.dart';
import 'package:shared_advisor_interface/presentation/services/audio/audio_player_service.dart';
import 'package:shared_advisor_interface/presentation/services/check_permission_service.dart';
import 'package:shared_advisor_interface/presentation/services/connectivity_service.dart';
import 'package:shared_advisor_interface/presentation/services/audio/audio_recorder_service.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatCubit(
        getIt.get<ChatsRepository>(),
        getIt.get<ConnectivityService>(),
        getIt.get<MainCubit>(),
        AudioRecorderServiceImp(),
        AudioPlayerServiceImpl(),
        getIt.get<CheckPermissionService>(),
        () => showErrorAlert(context),
        () => confirmSendAnswerAlert(context),
        () => deleteAudioMessageAlert(context),
        () => recordingIsNotPossibleAlert(context),
      ),
      child: const ChatContentWidget(),
    );
  }
}

class ChatContentWidget extends StatelessWidget {
  const ChatContentWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final S s = S.of(context);
    final ChatCubit chatCubit = context.read<ChatCubit>();
    final MainCubit mainCubit = context.read<MainCubit>();

    final ChatItem? questionFromDB =
        context.select((ChatCubit cubit) => cubit.state.questionFromDB);
    final CustomerProfileScreenArguments? appBarUpdateArguments =
        context.select((ChatCubit cubit) => cubit.state.appBarUpdateArguments);
    final ChatItemStatusType? questionStatus =
        context.select((ChatCubit cubit) => cubit.state.questionStatus);

    logger.d(appBarUpdateArguments?.clientName);

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
        child: Scaffold(
          body: Scaffold(
            appBar: ChatConversationAppBar(
                title: appBarUpdateArguments?.clientName,
                zodiacSign: appBarUpdateArguments?.zodiacSign ??
                    questionFromDB?.clientInformation?.zodiac,
                publicQuestionId:
                    chatCubit.chatScreenArguments.publicQuestionId,
                returnInQueueButtonOnTap: () async {
                  final dynamic needReturn = await showOkCancelAlert(
                    context: context,
                    title: s.doYouWantToRejectThisQuestion,
                    description: s.itWillGoBackIntoTheGeneralQueue,
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
                if (chatCubit.needActiveChatTab()) {
                  tabsTitles.add(chatCubit.isPublicChat()
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
                          onChangeOptionIndex: chatCubit.changeCurrentTabIndex,
                        );
                      }),
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
                        final AppError appError = context
                            .select((MainCubit cubit) => cubit.state.appError);

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

                if (chatCubit.needActiveChatTab() && currentIndex == 0) {
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
    okText: S.of(context).ok,
    actionOnOK: () {
      mainCubit.updateSessions();
      Get.close(2);
    },
    allowBarrierClick: false,
    isCancelEnabled: false,
  );
}

Future<bool?> confirmSendAnswerAlert(BuildContext context) async {
  final s = S.of(context);
  return await showOkCancelAlert(
    context: context,
    title: s.pleaseConfirmThatYourAnswerIsReadyToBeSent,
    okText: s.confirm,
    actionOnOK: () => Navigator.pop(context, true),
    allowBarrierClick: false,
    isCancelEnabled: true,
  );
}

Future<bool?> deleteAudioMessageAlert(BuildContext context) async {
  return await showDeleteAlert(
      context, S.of(context).doYouWantToDeleteThisAudioMessage);
}

Future<bool?> recordingIsNotPossibleAlert(BuildContext context) async {
  final s = S.of(context);
  return await showOkCancelAlert(
    context: context,
    title: s.recordingIsNotPossibleAllocateSpaceOnTheDevice,
    okText: s.ok,
    actionOnOK: () => Navigator.pop(context, true),
    allowBarrierClick: true,
    isCancelEnabled: false,
  );
}
