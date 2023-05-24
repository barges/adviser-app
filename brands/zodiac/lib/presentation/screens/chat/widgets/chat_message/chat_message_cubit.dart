import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:zodiac/data/models/chat/chat_message_model.dart';
import 'package:zodiac/services/websocket_manager/created_delivered_event.dart';
import 'package:zodiac/services/websocket_manager/websocket_manager.dart';

import 'chat_message_state.dart';

class ChatMessageCubit extends Cubit<ChatMessageState> {
  final ChatMessageModel _chatMessageModel;
  final String? _roomId;
  final int? _opponentId;
  final WebSocketManager _webSocketManager;

  StreamSubscription<CreatedDeliveredEvent>? _messageDeliveredSubscription;

  Timer? _resendTimer;

  int _resendCount = 0;
  ChatMessageCubit(
    this._chatMessageModel,
    this._roomId,
    this._opponentId,
    this._webSocketManager,
  ) : super(const ChatMessageState()) {
    if (_chatMessageModel.isOutgoing && !_chatMessageModel.isDelivered) {
      logger.d('CREATE');
      _setTimer();
      _messageDeliveredSubscription =
          _webSocketManager.updateMessageIdStream.listen((event) {
        if (event.mid == _chatMessageModel.mid) {
          _resendTimer?.cancel();
          _resendCount = 0;
          emit(state.copyWith(showResendWidget: false));
          _messageDeliveredSubscription?.cancel();
        }
      });
    }
  }

  @override
  Future<void> close() {
    _resendTimer?.cancel();
    _messageDeliveredSubscription?.cancel();
    return super.close();
  }

  void resendChatMessage() {
    emit(state.copyWith(showResendWidget: false));
    _resendMessage();
    _resendCount = 0;
    _setTimer();
  }

  void _resendMessage() {
    _webSocketManager.sendMessageToChat(
      message: _chatMessageModel,
      roomId: _roomId ?? '',
      opponentId: _opponentId ?? 0,
    );
  }

  void _setTimer() {
    _resendTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      logger.d('Timer');

      if (_resendCount < 3) {
        _resendMessage();
        _resendCount++;
      } else {
        emit(state.copyWith(showResendWidget: true));
        _resendTimer?.cancel();
      }
    });
  }
}
