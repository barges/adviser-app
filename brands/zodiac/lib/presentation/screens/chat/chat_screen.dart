import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_size/flutter_keyboard_size.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/ok_cancel_alert.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/show_delete_alert.dart';
import 'package:shared_advisor_interface/utils/utils.dart';
import 'package:zodiac/data/models/chat/user_data.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/infrastructure/di/inject_config.dart';
import 'package:zodiac/presentation/common_widgets/appbar/chat_conversation_app_bar.dart';
import 'package:zodiac/presentation/common_widgets/messages/app_success_widget.dart';
import 'package:zodiac/presentation/screens/chat/chat_cubit.dart';
import 'package:zodiac/presentation/screens/chat/widgets/chat_messages_list_widget.dart';
import 'package:zodiac/presentation/screens/chat/widgets/chat_text_input_widget.dart';
import 'package:zodiac/presentation/screens/chat/widgets/client_information_widget.dart';
import 'package:zodiac/zodiac_constants.dart';
import 'package:zodiac/zodiac_extensions.dart';

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
    return BlocProvider(
      create: (_) => zodiacGetIt.get<ChatCubit>(
          param1: ChatCubitParams(
              fromStartingChat: fromStartingChat,
              clientData: userData,
              underageConfirmDialog: (message) =>
                  _showUnderageConfirmDialog(context, message))),
      child: Builder(builder: (context) {
        final ChatCubit chatCubit = context.read<ChatCubit>();
        final bool chatIsActive =
            context.select((ChatCubit cubit) => cubit.state.chatIsActive);

        final bool offlineSessionIsActive = context
            .select((ChatCubit cubit) => cubit.state.offlineSessionIsActive);

        return WillPopScope(
          onWillPop: () async => (!chatIsActive && !offlineSessionIsActive),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Scaffold(
                backgroundColor: Theme.of(context).canvasColor,
                appBar: ChatConversationAppBar(
                  userData: userData,
                  onTap: chatCubit.changeClientInformationWidgetOpened,
                  backButtonOnTap: () => chatCubit.logoutChat(context),
                  endChatButtonOnTap: chatIsActive
                      ? () async {
                          bool? endChat = await showOkCancelAlert(
                            context: context,
                            title: SZodiac.of(context)
                                .doYouReallyWantToEndTheChatZodiac,
                            okText: SZodiac.of(context).yesZodiac,
                            cancelText: SZodiac.of(context).noZodiac,
                            allowBarrierClick: true,
                            isCancelEnabled: true,
                          );
                          if (endChat == true) {
                            chatCubit.endChat();
                          }
                        }
                      : null,
                ),
                body: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Column(
                      children: [
                        Expanded(
                          child: ChatMessagesListWidget(
                            fromStartingChat: fromStartingChat,
                          ),
                        ),
                        if (chatIsActive || offlineSessionIsActive)
                          Builder(builder: (context) {
                            final double focusedTextInputHeight =
                                context.select((ChatCubit cubit) =>
                                    cubit.state.textInputHeight);

                            context.select((ChatCubit cubit) =>
                                cubit.state.textInputFocused);

                            final double bottomPadding =
                                bottomPartTextInputHeight +
                                    (chatCubit.state.textInputFocused
                                        ? grabbingHeight +
                                            12.0 +
                                            ZodiacConstants
                                                .chatHorizontalPadding +
                                            focusedTextInputHeight
                                        : MediaQuery.of(context)
                                            .padding
                                            .bottom);
                            return Container(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              height: bottomPadding,
                            );
                          }),
                      ],
                    ),
                    Positioned(
                      top: 0.0,
                      right: 0.0,
                      left: 0.0,
                      child: Column(
                        children: [
                          ClientInformationWidget(
                            chatIsActive: chatIsActive,
                          ),
                          Builder(builder: (context) {
                            final bool showOfflineSessionsMessage =
                                context.select((ChatCubit cubit) =>
                                    cubit.state.showOfflineSessionsMessage);
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
                      ),
                    ),
                  ],
                ),
              ),
              if (chatIsActive || offlineSessionIsActive)
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
                        child: Builder(
                          builder: (context) {
                            return const ChatTextInputWidget();
                          },
                        ),
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
}

Future<bool?> _showUnderageConfirmDialog(
    BuildContext context, String message) async {
  return showDeleteAlert(context, message,
      deleteText: SZodiac.of(context).reportZodiac);
}
