import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zodiac/data/models/chat/chat_message_model.dart';
import 'package:zodiac/data/models/chat/user_data.dart';
import 'package:zodiac/presentation/screens/chat/chat_state.dart';
import 'package:zodiac/services/websocket_manager/websocket_manager.dart';

class ChatCubit extends Cubit<ChatState> {
  final WebSocketManager _webSocketManager;
  final UserData _userData;


  late final StreamSubscription<List<ChatMessageModel>> _messagesStream;

  ChatCubit(
      this._webSocketManager,
      this._userData,
      ) : super(const ChatState()) {
          _messagesStream = _webSocketManager.entitiesStream.listen((event) {
              emit(state.copyWith(messages: event));
          });

          _webSocketManager.reloadMessages(_userData.id ?? 0);
  }

  @override
  Future<void> close() {
    _messagesStream.cancel();
    return super.close();
  }

}