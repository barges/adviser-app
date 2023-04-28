import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zodiac/data/models/chat/chat_message_model.dart';
import 'package:zodiac/data/models/chat/user_data.dart';
import 'package:zodiac/presentation/screens/chat/chat_state.dart';
import 'package:zodiac/services/websocket_manager/websocket_manager.dart';

class ChatCubit extends Cubit<ChatState> {
  final WebSocketManager _webSocketManager;
  final UserData _userData;

  late final StreamSubscription<List<ChatMessageModel>> _messagesStream;

  final ScrollController messageListScrollController = ScrollController();

  final List<ChatMessageModel> _messages = [];

  ChatCubit(
    this._webSocketManager,
    this._userData,
  ) : super(const ChatState()) {
    _messagesStream = _webSocketManager.entitiesStream.listen((event) {
      _messages.addAll(event);

      emit(state.copyWith(messages: _messages));
    });

    reloadMessage();
  }

  @override
  Future<void> close() {
    _messagesStream.cancel();
    return super.close();
  }

  void reloadMessage({int? maxId}) {
    if (maxId == null) {
      _messages.clear();
    }
    _webSocketManager.reloadMessages(
      userId: _userData.id ?? 0,
      maxId: maxId,
    );
  }
}
