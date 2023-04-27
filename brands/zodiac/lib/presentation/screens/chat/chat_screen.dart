import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:zodiac/data/models/chat/chat_message_model.dart';
import 'package:zodiac/data/models/chat/user_data.dart';
import 'package:zodiac/infrastructure/di/inject_config.dart';
import 'package:zodiac/presentation/common_widgets/appbar/chat_conversation_app_bar.dart';
import 'package:zodiac/presentation/screens/chat/chat_cubit.dart';
import 'package:zodiac/services/websocket_manager/websocket_manager.dart';

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
      ),
      child: Builder(builder: (context) {
        final List<ChatMessageModel> messages =
            context.select((ChatCubit cubit) => cubit.state.messages);

        for (var element in messages) {
          logger.d(element);
        }

        return Scaffold(
          appBar: ChatConversationAppBar(
            userData: userData,
          ),
          body: ListView(
            shrinkWrap: true,
            reverse: true,
            children: messages.map((e) {
              return SizedBox(
                height: 48,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Text(e.type.name),
                ),
              );
            }).toList(),
          ),
        );
      }),
    );
  }
}
