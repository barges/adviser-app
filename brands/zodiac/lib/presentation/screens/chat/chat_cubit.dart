import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zodiac/data/models/chat/chat_message_model.dart';
import 'package:zodiac/data/models/chat/user_data.dart';
import 'package:zodiac/data/network/requests/profile_details_request.dart';
import 'package:zodiac/data/network/responses/profile_details_response.dart';
import 'package:zodiac/domain/repositories/zodiac_user_repository.dart';
import 'package:zodiac/presentation/screens/chat/chat_state.dart';
import 'package:zodiac/services/websocket_manager/websocket_manager.dart';

class ChatCubit extends Cubit<ChatState> {
  final WebSocketManager _webSocketManager;
  final bool _fromStartingChat;
  final UserData userData;
  final ZodiacUserRepository _userRepository;

  late final StreamSubscription<List<ChatMessageModel>> _messagesStream;

  final ScrollController messageListScrollController = ScrollController();

  final List<ChatMessageModel> _messages = [];

  ChatCubit(
    this._webSocketManager,
    this._fromStartingChat,
    this.userData,
    this._userRepository,
  ) : super(const ChatState()) {

    _messagesStream = _webSocketManager.entitiesStream.listen((event) {
      _messages.addAll(event);

      emit(state.copyWith(messages: _messages));
    });

    if(!_fromStartingChat){
      _webSocketManager.chatLogin(opponentId: userData.id ?? 0);
    }
    getClientInformation();
  }

  @override
  Future<void> close() {
    _messagesStream.cancel();
    return super.close();
  }

  void getMessageWithPagination({int? maxId}) {
    _webSocketManager.reloadMessages(
      opponentId: userData.id ?? 0,
      maxId: maxId,
    );
  }

  Future<void> getClientInformation() async {
    if (userData.id != null) {
      final ProfileDetailsResponse response = await _userRepository
          .getProfileDetails(ProfileDetailsRequest(userId: userData.id!));
      if (response.status == true) {
        emit(state.copyWith(clientInformation: response.result));
      }
    }
  }

  void changeClientInformationWidgetOpened() {
    emit(state.copyWith(
        clientInformationWidgetOpened: !state.clientInformationWidgetOpened));
  }
}
