import 'package:flutter_bloc/flutter_bloc.dart';

import 'chat_message_state.dart';

class ChatMessageCubit extends Cubit<ChatMessageState> {
  ChatMessageCubit() : super(const ChatMessageState());
}
