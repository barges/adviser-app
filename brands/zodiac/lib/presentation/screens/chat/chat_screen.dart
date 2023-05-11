import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_size/flutter_keyboard_size.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:shared_advisor_interface/utils/utils.dart';
import 'package:zodiac/data/models/chat/user_data.dart';
import 'package:zodiac/domain/repositories/zodiac_user_repository.dart';
import 'package:zodiac/infrastructure/di/inject_config.dart';
import 'package:zodiac/presentation/common_widgets/appbar/chat_conversation_app_bar.dart';
import 'package:zodiac/presentation/screens/chat/chat_cubit.dart';
import 'package:zodiac/presentation/screens/chat/widgets/chat_messages_list_widget.dart';
import 'package:zodiac/presentation/screens/chat/widgets/chat_text_input_widget.dart';
import 'package:zodiac/presentation/screens/chat/widgets/client_information_widget.dart';
import 'package:zodiac/services/websocket_manager/websocket_manager.dart';
import 'package:zodiac/zodiac_constants.dart';
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
    return BlocProvider(
      create: (_) => ChatCubit(
        zodiacGetIt.get<WebSocketManager>(),
        fromStartingChat,
        userData,
        zodiacGetIt.get<ZodiacUserRepository>(),
        zodiacGetIt.get<ZodiacMainCubit>(),
        MediaQuery.of(context).size.height,
      ),
      child: Builder(builder: (context) {
        final ChatCubit chatCubit = context.read<ChatCubit>();

        return Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Scaffold(
              appBar: ChatConversationAppBar(
                userData: userData,
                onTap: chatCubit.changeClientInformationWidgetOpened,
                backButtonOnTap: () {
                  chatCubit.updateSessions();
                  context.pop();
                },
              ),
              body: SafeArea(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Column(
                      children: [
                        const Expanded(
                          child: ChatMessagesListWidget(),
                        ),
                        Builder(builder: (context) {
                          final double bottomTextAreaHeight = context.select(
                              (ChatCubit cubit) =>
                                  cubit.state.bottomTextAreaHeight);

                          final double textInputHeight = context.select(
                              (ChatCubit cubit) => cubit.state.textInputHeight);

                          final double bottomPadding =
                              (MediaQueryData.fromWindow(window)
                                              .viewPadding
                                              .bottom >
                                          0.0
                                      ? MediaQueryData.fromWindow(window)
                                          .viewPadding
                                          .bottom
                                      : chatCubit.state.textInputFocused
                                          ? 12.0
                                          : 0.0) +
                                  bottomTextAreaHeight +
                                  (chatCubit.state.textInputFocused
                                      ? grabbingHeight +
                                          ZodiacConstants
                                              .chatHorizontalPadding +
                                          textInputHeight
                                      : 0.0);
                          return SizedBox(
                            height: bottomPadding,
                          );
                        }),
                      ],
                    ),
                    const Positioned(
                      top: 0.0,
                      right: 0.0,
                      left: 0.0,
                      child: ClientInformationWidget(),
                    ),
                  ],
                ),
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
                        return const ChatTextInputWidget();
                      },
                    ),
                  ),
                );
              }),
            ),
          ],
        );
      }),
    );
  }
}
