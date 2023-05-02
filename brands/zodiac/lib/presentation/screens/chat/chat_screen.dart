import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:zodiac/data/models/chat/chat_message_model.dart';
import 'package:zodiac/data/models/chat/user_data.dart';
import 'package:zodiac/domain/repositories/zodiac_user_repository.dart';
import 'package:zodiac/infrastructure/di/inject_config.dart';
import 'package:zodiac/presentation/common_widgets/appbar/chat_conversation_app_bar.dart';
import 'package:zodiac/presentation/screens/chat/chat_cubit.dart';
import 'package:zodiac/presentation/screens/chat/widgets/chat_message_widget.dart';
import 'package:zodiac/presentation/screens/chat/widgets/client_information_widget.dart';
import 'package:zodiac/services/websocket_manager/websocket_manager.dart';
import 'package:zodiac/zodiac_constants.dart';

class ChatScreen extends StatelessWidget {
  final UserData userData;

  const ChatScreen({
    Key? key,
    required this.userData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatCubit(
        zodiacGetIt.get<WebSocketManager>(),
        userData,
        zodiacGetIt.get<ZodiacUserRepository>(),
      ),
      child: Builder(builder: (context) {
        final ChatCubit chatCubit = context.read<ChatCubit>();
        final List<ChatMessageModel> messages =
            context.select((ChatCubit cubit) => cubit.state.messages);

        for (var element in messages) {
          logger.d(element);
        }

        return Scaffold(
          appBar: ChatConversationAppBar(
            userData: userData,
            onTap: chatCubit.changeClientInformationWidgetOpened,
          ),
          body: SafeArea(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                ListView.separated(
                  padding: const EdgeInsets.all(
                    ZodiacConstants.chatHorizontalPadding,
                  ),
                  shrinkWrap: true,
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ChatMessageWidget(
                      chatMessageModel: messages[index],
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(
                      height: 4.0,
                    );
                  },
                ),
                const Positioned(
                  top: 0.0,
                  right: 0.0,
                  left: 0.0,
                  child: ClientInformationWidget(),
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
