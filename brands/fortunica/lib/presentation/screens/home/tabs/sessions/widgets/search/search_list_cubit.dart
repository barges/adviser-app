import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortunica/data/models/chats/chat_item.dart';
import 'package:fortunica/data/network/responses/questions_list_response.dart';
import 'package:fortunica/domain/repositories/fortunica_chats_repository.dart';
import 'package:fortunica/fortunica_constants.dart';
import 'package:fortunica/presentation/screens/customer_sessions/customer_sessions_screen.dart';
import 'package:fortunica/presentation/screens/home/tabs/sessions/widgets/search/search_list_state.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.gr.dart';
import 'package:shared_advisor_interface/services/connectivity_service.dart';

class SearchListCubit extends Cubit<SearchListState> {
  final FortunicaChatsRepository _repository;
  final double _screenHeight;
  final VoidCallback _closeSearch;
  final ConnectivityService _connectivityService;

  final ScrollController conversationsScrollController = ScrollController();

  final List<ChatItem> _conversationsList = [];

  String? _conversationsLastItem;
  bool _conversationsHasMore = true;
  bool _isLoading = false;

  SearchListCubit(
    this._repository,
    this._connectivityService,
    this._screenHeight,
    this._closeSearch,
  ) : super(const SearchListState()) {
    conversationsScrollController.addListener(() {
      if (!_isLoading &&
          conversationsScrollController.position.extentAfter <= _screenHeight) {
        getConversations();
      }
    });

    getConversations();
  }

  @override
  Future<void> close() {
    conversationsScrollController.dispose();

    return super.close();
  }

  Future<void> getConversations({
    String? searchText,
    bool refresh = false,
  }) async {
    _isLoading = true;
    try {
      if (refresh) {
        _conversationsHasMore = true;
        _conversationsLastItem = null;
        _conversationsList.clear();
      }
      if (_conversationsHasMore &&
          await _connectivityService.checkConnection()) {
        final QuestionsListResponse result =
            await _repository.getConversationsList(
          limit: FortunicaConstants.questionsLimit,
          lastItem: _conversationsLastItem,
          search: searchText?.isNotEmpty == true ? searchText : null,
        );

        _conversationsHasMore = result.hasMore ?? true;
        _conversationsLastItem = result.lastItem;

        _conversationsList.addAll(result.questions ?? const []);

        emit(
          state.copyWith(
            conversationsList: List.of(
              _conversationsList,
            ),
          ),
        );
      }
    } catch (e) {
      logger.d(e);
    } finally {
      _isLoading = false;
    }
  }

  void goToCustomerSessions(BuildContext context, ChatItem question) {
    _closeSearch();
    context.push(
      route: FortunicaCustomerSessions(
        customerSessionsScreenArguments:
            CustomerSessionsScreenArguments(question: question, marketIndex: 0),
      ),
    );
  }
}
