import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_advisor_interface/data/models/chats/chat_item.dart';
import 'package:shared_advisor_interface/data/network/responses/questions_list_response.dart';
import 'package:shared_advisor_interface/domain/repositories/chats_repository.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/presentation/resources/app_arguments.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/resources/app_routes.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/sessions/widgets/search/search_list_state.dart';
import 'package:shared_advisor_interface/presentation/services/connectivity_service.dart';

class SearchListCubit extends Cubit<SearchListState> {
  final ChatsRepository _repository;
  final double screenHeight;
  final VoidCallback closeSearch;
  final ConnectivityService _connectivityService =
      getIt.get<ConnectivityService>();

  final BehaviorSubject _searchStream = BehaviorSubject<String>();

  final TextEditingController searchTextController = TextEditingController();
  final ScrollController conversationsScrollController = ScrollController();

  final List<ChatItem> _conversationsList = [];

  late final StreamSubscription _searchSubscription;

  String? _conversationsLastItem;
  bool _conversationsHasMore = true;
  bool _isLoading = false;

  SearchListCubit(
    this._repository,
    this.screenHeight,
    this.closeSearch,
  ) : super(const SearchListState()) {
    _searchSubscription = _searchStream
        .debounceTime(const Duration(milliseconds: 500))
        .listen((event) async {
      getConversations(refresh: true);
    });

    conversationsScrollController.addListener(() {
      ///TODO: Remove context
      if (!_isLoading &&
          conversationsScrollController.position.extentAfter <= screenHeight) {
        getConversations();
      }
    });

    getConversations();
  }

  @override
  Future<void> close() {
    _searchStream.close();
    _searchSubscription.cancel();
    searchTextController.dispose();
    conversationsScrollController.dispose();

    return super.close();
  }

  void changeText(String text) {
    _searchStream.add(text);
  }

  Future<void> getConversations({bool refresh = false}) async {
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
          limit: AppConstants.questionsLimit,
          lastItem: _conversationsLastItem,
          search: searchTextController.text.isNotEmpty
              ? searchTextController.text
              : null,
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

  void goToCustomerSessions(ChatItem question) {
    closeSearch();
    Get.toNamed(
      AppRoutes.customerSessions,
      arguments:
          CustomerSessionsScreenArguments(question: question, marketIndex: 0),
    );
  }
}
