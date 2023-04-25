import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zodiac/presentation/screens/chat/chat_state.dart';
import 'package:zodiac/services/websocket_manager/websocket_manager.dart';

class ChatCubit extends Cubit<ChatState> {
  final WebSocketManager _webSocketManager;
  final int _opponentId;

  ChatCubit(
      this._webSocketManager,
      this._opponentId,
      ) : super(const ChatState()) {

  }

}