import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_size/flutter_keyboard_size.dart';
import 'package:scrollview_observer/scrollview_observer.dart';
import 'package:shared_advisor_interface/data/models/app_error/app_error.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/ok_cancel_alert.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/show_delete_alert.dart';
import 'package:shared_advisor_interface/utils/utils.dart';
import 'package:zodiac/data/models/chat/chat_message_model.dart';
import 'package:zodiac/data/models/chat/user_data.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/infrastructure/di/inject_config.dart';
import 'package:zodiac/presentation/common_widgets/appbar/chat_conversation_app_bar.dart';
import 'package:zodiac/presentation/common_widgets/empty_list_widget.dart';
import 'package:zodiac/presentation/common_widgets/messages/app_error_widget.dart';
import 'package:zodiac/presentation/common_widgets/messages/app_success_widget.dart';
import 'package:zodiac/presentation/screens/chat/chat_cubit.dart';
import 'package:zodiac/presentation/screens/chat/widgets/active_chat_input_field_widget.dart';
import 'package:zodiac/presentation/screens/chat/widgets/chat_messages_list_widget.dart';
import 'package:zodiac/presentation/screens/chat/widgets/text_input_field/chat_text_input_widget.dart';
import 'package:zodiac/presentation/screens/chat/widgets/client_information_widget.dart';
import 'package:zodiac/zodiac_constants.dart';
import 'package:zodiac/zodiac_extensions.dart';
import 'package:zodiac/zodiac_main_cubit.dart';

class ChatScreen extends StatelessWidget {
  final UserData userData;
  final bool fromStartingChat;

  const ChatScreen({
    Key? key,
    required this.userData,
    this.fromStartingChat = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocProvider(
      create: (_) => zodiacGetIt.get<ChatCubit>(
          param1: ChatCubitParams(
        fromStartingChat: fromStartingChat,
        clientData: userData,
        underageConfirmDialog: (message) =>
            _showUnderageConfirmDialog(context, message),
        deleteAudioMessageAlert: () => _deleteAudioMessageAlert(context),
      )),
      child: Builder(builder: (context) {
        final ChatCubit chatCubit = context.read<ChatCubit>();
        final bool chatIsActive =
            context.select((ChatCubit cubit) => cubit.state.chatIsActive);

        final bool offlineSessionIsActive = context
            .select((ChatCubit cubit) => cubit.state.offlineSessionIsActive);

        final bool isVisibleTextField =
            context.select((ChatCubit cubit) => cubit.state.isVisibleTextField);

        final bool showTextField =
            (chatIsActive || offlineSessionIsActive) && isVisibleTextField;

        return WillPopScope(
          onWillPop: () async {
            if (chatIsActive) {
              _endChat(context);
            } else if (offlineSessionIsActive) {
              _endOfflineSession(context);
            } else {
              chatCubit.logoutChat(context);
            }
            return false;
          },
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Scaffold(
                backgroundColor: theme.canvasColor,
                appBar: ChatConversationAppBar(
                  userData: userData,
                  onTap: chatCubit.changeClientInformationWidgetOpened,
                  backButtonOnTap: () {
                    if (offlineSessionIsActive) {
                      _endOfflineSession(context);
                    } else {
                      chatCubit.logoutChat(context);
                    }
                  },
                  endChatButtonOnTap:
                      chatIsActive ? () => _endChat(context) : null,
                ),
                body: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ListViewObserver(
                      controller: chatCubit.observerController,
                      child: Column(
                        children: [
                          Expanded(
                            child: Builder(builder: (context) {
                              final List<ChatMessageModel>? messages =
                                  context.select((ChatCubit cubit) =>
                                      cubit.state.messages);
                              if (messages != null) {
                                if (messages.isNotEmpty) {
                                  return ChatMessagesListWidget(
                                    fromStartingChat: fromStartingChat,
                                    messages: messages,
                                  );
                                } else {
                                  return CustomScrollView(
                                    slivers: [
                                      SliverFillRemaining(
                                        hasScrollBody: false,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            EmptyListWidget(
                                              title: SZodiac.of(context)
                                                  .noMessagesYetZodiac,
                                              label: SZodiac.of(context)
                                                  .yourChatHistoryWillAppearHereZodiac,
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  );
                                }
                              } else {
                                return const SizedBox.shrink();
                              }
                            }),
                          ),
                          if (chatIsActive || offlineSessionIsActive)
                            const _BottomPaddingContainerIfHasTextInputField(),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 0.0,
                      right: 0.0,
                      left: 0.0,
                      child: Builder(builder: (context) {
                        final bool showOfflineSessionsMessage = context.select(
                            (ChatCubit cubit) =>
                                cubit.state.showOfflineSessionsMessage);

                        return Column(
                          children: [
                            ClientInformationWidget(
                              chatIsActive: chatIsActive,
                            ),
                            Builder(builder: (context) {
                              final AppError appError = context.select(
                                  (ZodiacMainCubit cubit) =>
                                      cubit.state.appError);
                              final bool internetConnectionIsAvailable =
                                  context.select((MainCubit cubit) => cubit
                                      .state.internetConnectionIsAvailable);

                              return AppErrorWidget(
                                errorMessage: !internetConnectionIsAvailable
                                    ? SZodiac.of(context)
                                        .noInternetConnectionZodiac
                                    : appError.getMessage(context),
                                roundedCorners: !showOfflineSessionsMessage,
                                close: internetConnectionIsAvailable
                                    ? chatCubit.closeErrorMessage
                                    : null,
                              );
                            }),
                            Builder(builder: (context) {
                              final Duration? offlineSessionTimerValue =
                                  context.select((ChatCubit cubit) =>
                                      cubit.state.offlineSessionTimerValue);

                              return AppSuccessWidget(
                                title: SZodiac.of(context).chatEndedZodiac,
                                message: showOfflineSessionsMessage &&
                                        offlineSessionTimerValue != null
                                    ? SZodiac.of(context)
                                        .youAreAbleToWriteWithinZodiac(
                                            offlineSessionTimerValue
                                                .offlineSessionTimerFormat(
                                                    context))
                                    : '',
                                onClose: chatCubit.closeOfflineSessionsMessage,
                              );
                            }),
                          ],
                        );
                      }),
                    ),
                  ],
                ),
              ),
              if (showTextField)
                KeyboardSizeProvider(
                  child: Builder(builder: (context) {
                    final bool needBarrierColor = context.select(
                        (ChatCubit cubit) => cubit.state.isStretchedTextField);
                    return SafeArea(
                      bottom: false,
                      child: Material(
                        type: needBarrierColor
                            ? MaterialType.canvas
                            : MaterialType.transparency,
                        color: needBarrierColor
                            ? Utils.getOverlayColor(context)
                            : Colors.transparent,
                        child: const ActiveChatInputFieldWidget(),
                      ),
                    );
                  }),
                ),
            ],
          ),
        );
      }),
    );
  }

  Future<bool?> _deleteAudioMessageAlert(BuildContext context) async {
    return await showDeleteAlert(
        context, SZodiac.of(context).doYouWantToDeleteThisAudioMessageZodiac);
  }

  Future<void> _endChat(BuildContext context) async {
    final ChatCubit chatCubit = context.read<ChatCubit>();

    bool? endChat = await showOkCancelAlert(
      context: context,
      title: SZodiac.of(context).doYouReallyWantToEndTheChatZodiac,
      okText: SZodiac.of(context).yesZodiac,
      cancelText: SZodiac.of(context).noZodiac,
      allowBarrierClick: true,
      isCancelEnabled: true,
    );
    if (endChat == true) {
      chatCubit.endChat();
    }
  }

  Future<void> _endOfflineSession(BuildContext context) async {
    final ChatCubit chatCubit = context.read<ChatCubit>();

    bool? endOfflineSession = await showOkCancelAlert(
      context: context,
      title: SZodiac.of(context).doYouReallyWantToCloseTheChatZodiac,
      okText: SZodiac.of(context).yesZodiac,
      cancelText: SZodiac.of(context).noZodiac,
      allowBarrierClick: true,
      isCancelEnabled: true,
    );
    if (endOfflineSession == true) {
      chatCubit.closeOfflineSession();
    }
  }
}

Future<bool?> _showUnderageConfirmDialog(
    BuildContext context, String message) async {
  return showDeleteAlert(
    context,
    message,
    deleteText: SZodiac.of(context).reportZodiac,
    swapButtonColorsForAndroid: true,
  );
}

class _BottomPaddingContainerIfHasTextInputField extends StatelessWidget {
  const _BottomPaddingContainerIfHasTextInputField({Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double focusedTextInputHeight =
        context.select((ChatCubit cubit) => cubit.state.textInputHeight);

    context.select((ChatCubit cubit) => cubit.state.textInputFocused);

    context.select((ChatCubit cubit) => cubit.state.repliedMessage);

    final double bottomPadding = constBottomPartTextInputHeight +
        (context.read<ChatCubit>().state.textInputFocused
            ? constGrabbingHeight +
                ZodiacConstants.chatVerticalPadding +
                12.0 +
                focusedTextInputHeight
            : MediaQuery.of(context).padding.bottom);
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      height: bottomPadding,
    );
  }
}
