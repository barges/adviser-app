import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:zodiac/data/models/chats/chat_item_zodiac.dart';
import 'package:zodiac/data/network/requests/chat_entities_request.dart';
import 'package:zodiac/data/network/responses/chat_entities_response.dart';
import 'package:zodiac/domain/repositories/zodiac_chats_repository.dart';
import 'package:zodiac/presentation/screens/home/tabs/sessions/sessions_state.dart';

class SessionsCubit extends Cubit<SessionsState> {
  final ZodiacChatsRepository _chatsRepository;

  final ScrollController chatsListScrollController = ScrollController();
  final TextEditingController searchEditingController = TextEditingController();

  bool _isLoading = false;
 final List<ZodiacChatsListItem> _chatsList = [];

  SessionsCubit(
    this._chatsRepository,
    double screenHeight,
  ) : super(const SessionsState()) {
    chatsListScrollController.addListener(() {
      if (!_isLoading &&
          chatsListScrollController.position.extentAfter <= screenHeight) {
        _getChatsList();
      }
    });

    _getChatsList();
  }

  @override
  Future<void> close() async {
    chatsListScrollController.dispose();

    super.close();
  }

  Future<void> refreshChatsList() async {
    await _getChatsList(refresh: true);
  }

  Future<void> _getChatsList({bool refresh = false}) async {
    try {
      _isLoading = true;
      if (refresh) {
        _chatsList.clear();
      }

      final ChatEntitiesResponse response = await _chatsRepository.getChatsList(
        ChatEntitiesRequest(
          count: 20,
          offset: _chatsList.length,
        ),
      );

      List<ZodiacChatsListItem>? chatsList = response.result;
      _chatsList.addAll(chatsList ?? []);
      emit(state.copyWith(chatList: List.of(_chatsList)));
    } catch (e) {
      logger.d(e);
    } finally {
      _isLoading = false;
    }
  }
}
