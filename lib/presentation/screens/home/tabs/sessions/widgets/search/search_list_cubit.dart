import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_advisor_interface/data/models/chats/chat_item.dart';
import 'package:shared_advisor_interface/data/network/responses/questions_list_response.dart';
import 'package:shared_advisor_interface/domain/repositories/sessions_repository.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/sessions/sessions_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/sessions/widgets/search/search_list_state.dart';

class SearchListCubit extends Cubit<SearchListState> {
  final ChatsRepository _repository;
  final BuildContext context;
  final MainCubit _mainCubit = getIt.get<MainCubit>();

  final BehaviorSubject _searchStream = BehaviorSubject<String>();

  final TextEditingController searchTextController = TextEditingController();
  final ScrollController historyScrollController = ScrollController();

  final List<ChatItem> _historyQuestionsList = [];

  late final StreamSubscription _searchSubscription;

  bool _hasMore = true;
  int _historyPage = 1;

  SearchListCubit(this._repository, this.context)
      : super(const SearchListState()) {
    _searchSubscription = _searchStream
        .debounceTime(const Duration(milliseconds: 500))
        .listen((event) async {
      getHistoryList(refresh: true);
    });

    historyScrollController.addListener(() {
      if (historyScrollController.position.extentAfter <=
          MediaQuery.of(context).size.height) {
        getHistoryList();
      }
    });

    getHistoryList();
  }

  @override
  Future<void> close() {
    _searchStream.close();
    _searchSubscription.cancel();
    searchTextController.dispose();
    historyScrollController.dispose();

    return super.close();
  }

  void changeText(String text) {
    _searchStream.add(text);
  }

  Future<void> getHistoryList({bool refresh = false}) async {
    if (refresh) {
      _hasMore = true;
      _historyPage = 1;
      _historyQuestionsList.clear();
    }
    if (_hasMore && _mainCubit.state.internetConnectionIsAvailable) {
      final QuestionsListResponse result = await _repository.getHistoryList(
        limit: questionsLimit,
        page: _historyPage++,
        search: searchTextController.text.isNotEmpty
            ? searchTextController.text
            : null,
      );

      _hasMore = result.hasMore ?? true;

      _historyQuestionsList.addAll(result.questions ?? const []);

      emit(
        state.copyWith(
          historyQuestionsList: List.of(_historyQuestionsList),
        ),
      );
    }
  }
}
