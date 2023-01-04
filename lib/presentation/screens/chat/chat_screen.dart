import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/data/models/app_errors/app_error.dart';
import 'package:shared_advisor_interface/data/models/app_errors/empty_error.dart';
import 'package:shared_advisor_interface/data/models/app_success/app_success.dart';
import 'package:shared_advisor_interface/data/models/app_success/empty_success.dart';
import 'package:shared_advisor_interface/data/models/chats/chat_item.dart';
import 'package:shared_advisor_interface/data/models/enums/chat_item_status_type.dart';
import 'package:shared_advisor_interface/domain/repositories/chats_repository.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/appbar/chat_conversation_app_bar.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/choose_option_widget.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/customer_profile/customer_profile_widget.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/messages/app_error_widget.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/messages/app_succes_widget.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/ok_cancel_alert.dart';
import 'package:shared_advisor_interface/presentation/resources/app_arguments.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/chat_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/active_chat_input_field_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/active_chat_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/history/history_widget.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatCubit(
          getIt.get<ChatsRepository>(),
          () => _showErrorAlert(context),
          () => _confirmSendAnswerAlert(context)),
      child: Builder(
        builder: (context) {
          final S s = S.of(context);
          final ChatCubit chatCubit = context.read<ChatCubit>();

          final ChatItem? questionFromDB =
              context.select((ChatCubit cubit) => cubit.state.questionFromDB);
          final CustomerProfileScreenArguments? appBarUpdateArguments = context
              .select((ChatCubit cubit) => cubit.state.appBarUpdateArguments);
          final ChatItemStatusType? questionStatus =
              context.select((ChatCubit cubit) => cubit.state.questionStatus);

          return WillPopScope(
            onWillPop: () => Future.value(
                !(chatCubit.chatScreenArguments.publicQuestionId != null &&
                    questionStatus == ChatItemStatusType.taken)),
            child: Scaffold(
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
                                (ChatCubit cubit) =>
                                    cubit.state.currentTabIndex);
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
                          if (chatCubit.needActiveChatTab()) {
                            tabs.add(const ActiveChatWidget());
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
                                      storyId: chatCubit.chatScreenArguments
                                          .storyIdForHistory,
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
                                (ChatCubit cubit) =>
                                    cubit.state.currentTabIndex);
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
                    final int currentIndex = context.select(
                        (ChatCubit cubit) => cubit.state.currentTabIndex);
                    final ChatItemStatusType? questionStatus = context.select(
                        (ChatCubit cubit) => cubit.state.questionStatus);

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
          );
        },
      ),
    );
  }
}

Future<void> _showErrorAlert(BuildContext context) async {
  await showOkCancelAlert(
    context: context,
    title: getIt.get<MainCubit>().state.appError.getMessage(context),
    okText: S.of(context).ok,
    actionOnOK: () {
      getIt.get<MainCubit>().updateSessions();
      Get.close(2);
    },
    allowBarrierClick: false,
    isCancelEnabled: false,
  );
}

Future<bool?> _confirmSendAnswerAlert(BuildContext context) async {
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
