import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_advisor_interface/data/models/chats/chat_item.dart';
import 'package:shared_advisor_interface/data/models/enums/markets_type.dart';
import 'package:shared_advisor_interface/data/network/responses/questions_list_response.dart';
import 'package:shared_advisor_interface/domain/repositories/chats_repository.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/sessions/sessions_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/sessions/widgets/search/search_list_state.dart';

class SearchListCubit extends Cubit<SearchListState> {
  final ChatsRepository _repository;
  final BuildContext context;
  final MarketsType marketsType;
  final MainCubit _mainCubit = getIt.get<MainCubit>();

  final BehaviorSubject _searchStream = BehaviorSubject<String>();

  final TextEditingController searchTextController = TextEditingController();
  final ScrollController conversationsScrollController = ScrollController();

  final List<ChatItem> _conversationsList = [];

  late final StreamSubscription _searchSubscription;

  String? _conversationsLastItem;
  bool _conversationsHasMore = true;

  SearchListCubit(
    this._repository,
    this.context,
    this.marketsType,
  ) : super(const SearchListState()) {
    _searchSubscription = _searchStream
        .debounceTime(const Duration(milliseconds: 500))
        .listen((event) async {
      getConversations(refresh: true);
    });

    conversationsScrollController.addListener(() {
      if (conversationsScrollController.position.extentAfter <=
          MediaQuery.of(context).size.height) {
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
    if (refresh) {
      _conversationsHasMore = true;
      _conversationsLastItem = null;
      _conversationsList.clear();
    }
    if (_conversationsHasMore &&
        _mainCubit.state.internetConnectionIsAvailable) {
      final QuestionsListResponse result =
          await _repository.getConversationsList(
        limit: questionsLimit,
        filtersLanguage:
            marketsType != MarketsType.all ? marketsType.name : null,
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
  }
}
