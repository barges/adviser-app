import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:shared_advisor_interface/infrastructure/di/brand_manager.dart';
import 'package:zodiac/data/models/chats/chat_item_zodiac.dart';
import 'package:zodiac/data/network/requests/hide_chat_request.dart';
import 'package:zodiac/data/network/requests/list_request.dart';
import 'package:zodiac/data/network/responses/base_response.dart';
import 'package:zodiac/data/network/responses/chat_entities_response.dart';
import 'package:zodiac/domain/repositories/zodiac_chats_repository.dart';
import 'package:zodiac/presentation/screens/home/tabs/sessions/sessions_state.dart';
import 'package:zodiac/zodiac.dart';
import 'package:zodiac/zodiac_main_cubit.dart';

const int _count = 20;

class SessionsCubit extends Cubit<SessionsState> {
  final ZodiacChatsRepository _chatsRepository;
  final BrandManager _brandManager;
  final ZodiacMainCubit _zodiacMainCubit;

  StreamSubscription? _currentBrandSubscription;
  StreamSubscription? _updateSessionsSubscription;

  final ScrollController chatsListScrollController = ScrollController();
  final TextEditingController searchEditingController = TextEditingController();

  bool _isLoading = false;
  bool _hasMore = true;
  final List<ZodiacChatsListItem> _chatsList = [];

  SessionsCubit(
    this._chatsRepository,
    this._brandManager,
    this._zodiacMainCubit,
    double screenHeight,
  ) : super(const SessionsState()) {
    if (_brandManager.getCurrentBrand().brandAlias == ZodiacBrand.alias) {
      _getChatsList();
    } else {
      _currentBrandSubscription =
          _brandManager.listenCurrentBrandStream((value) async {
        if (value.brandAlias == ZodiacBrand.alias) {
          await _getChatsList();
          _currentBrandSubscription?.cancel();
        }
      });
    }

    chatsListScrollController.addListener(() {
      if (!_isLoading &&
          chatsListScrollController.position.extentAfter <= screenHeight) {
        _getChatsList();
      }
    });

    _updateSessionsSubscription =
        _zodiacMainCubit.sessionsUpdateTrigger.listen((value) {
      refreshChatsList();
    });
  }

  @override
  Future<void> close() async {
    chatsListScrollController.dispose();
    _currentBrandSubscription?.cancel();
    _updateSessionsSubscription?.cancel();
    super.close();
  }

  Future<void> refreshChatsList() async {
    await _getChatsList(refresh: true);
  }

  Future<void> _getChatsList({bool refresh = false}) async {
    try {
      if (!_isLoading) {
        _isLoading = true;
        if (refresh) {
          _chatsList.clear();
          _hasMore = true;
        }
        if (_hasMore) {
          final ChatEntitiesResponse response =
              await _chatsRepository.getChatsList(
            ListRequest(
              count: _count,
              offset: _chatsList.length,
            ),
          );

          List<ZodiacChatsListItem>? chatsList = response.result;
          _chatsList.addAll(chatsList ?? []);

          _hasMore = response.count != null &&
              _chatsList.length < int.parse(response.count!);

          emit(state.copyWith(chatList: List.of(_chatsList)));
        }

        _isLoading = false;
      }
    } catch (e) {
      logger.d(e);

      _isLoading = false;
    }
  }

  Future<void> hideChat(int? chatId) async {
    if (chatId != null) {
      try {
        BaseResponse response =
            await _chatsRepository.hideChat(HideChatRequest(chatId: chatId));
        if (response.status == true) {
          List<ZodiacChatsListItem> newChatsList =
              List.from(state.chatList ?? []);
          newChatsList.removeWhere((element) => element.id == chatId);
          emit(state.copyWith(chatList: newChatsList));
        }
      } catch (e) {
        logger.d(e);
      }
    }
  }

  void clearErrorMessage() {
    _zodiacMainCubit.clearErrorMessage();
  }
}
