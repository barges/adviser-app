import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/data/cache/caching_manager.dart';
import 'package:shared_advisor_interface/data/models/chats/chat_item.dart';
import 'package:shared_advisor_interface/data/models/enums/fortunica_user_status.dart';
import 'package:shared_advisor_interface/data/models/enums/markets_type.dart';
import 'package:shared_advisor_interface/data/models/enums/questions_type.dart';
import 'package:shared_advisor_interface/data/network/responses/questions_list_response.dart';
import 'package:shared_advisor_interface/domain/repositories/sessions_repository.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/sessions/sessions_state.dart';

const int questionsLimit = 20;

class SessionsCubit extends Cubit<SessionsState> {
  final ChatsRepository _repository = getIt.get<ChatsRepository>();
  final CachingManager cacheManager;
  final ScrollController publicQuestionsController = ScrollController();
  final ScrollController privateQuestionsController = ScrollController();
  final MainCubit mainCubit = getIt.get<MainCubit>();
  late final VoidCallback disposeUserStatusListen;
  late final VoidCallback disposeUserProfileListen;

  final List<ChatItemType> filters = [
    ChatItemType.all,
    ChatItemType.ritual,
    ChatItemType.private,
  ];
  final List<ChatItem> _publicQuestions = [];
  final List<ChatItem> _privateQuestionsWithHistory = [];

  String? _lastId;
  bool hasMore = true;
  bool _publicHasMore = true;
  bool _historyHasMore = true;
  int _historyPage = 1;

  SessionsCubit(this.cacheManager) : super(const SessionsState()) {
    publicQuestionsController.addListener(() async {
      if (!mainCubit.state.isLoading &&
          publicQuestionsController.position.extentAfter <= Get.height) {
        await getPublicQuestions();
      }
    });
    privateQuestionsController.addListener(() async {
      if (!mainCubit.state.isLoading &&
          privateQuestionsController.position.extentAfter <= Get.height) {
        await getHistoryList();
      }
    });
    disposeUserStatusListen = cacheManager.listenCurrentUserStatus((value) {
      getQuestions(
        status: value.status,
      );
    });
    disposeUserProfileListen = cacheManager.listenUserProfile((userProfile) {
      final List<MarketsType> userMarkets = [
        MarketsType.all,
        ...userProfile.activeLanguages ?? [],
      ];
      emit(state.copyWith(userMarkets: userMarkets));
    });
  }

  @override
  Future<void> close() async {
    publicQuestionsController.dispose();
    privateQuestionsController.dispose();
    disposeUserProfileListen.call();
    disposeUserStatusListen.call();
    return super.close();
  }

  Future<void> getQuestions({
    FortunicaUserStatus? status,
  }) async {
    getPublicQuestions(
      status: status,
      refresh: true,
    );
    getPrivateQuestions(
      status: status,
      refresh: true,
    );
  }

  void changeMarketIndexForPublic(int newIndex) {
    emit(state.copyWith(currentMarketIndexForPublic: newIndex));
    getPublicQuestions(refresh: true);
  }

  void changeMarketIndexForPrivate(int newIndex) {
    emit(state.copyWith(currentMarketIndexForPrivate: newIndex));
    getPrivateQuestions(refresh: true);
  }

  void changeCurrentOptionIndex(int newIndex) {
    emit(state.copyWith(currentOptionIndex: newIndex));
  }

  void changeFilterIndex(int newIndex) {
    emit(state.copyWith(currentFilterIndex: newIndex));
    getPrivateQuestions(refresh: true);
  }

  void openSearch() {
    emit(state.copyWith(searchIsOpen: true));
  }

  void closeSearch() {
    emit(state.copyWith(searchIsOpen: false));
  }

  Future<void> getPublicQuestions(
      {FortunicaUserStatus? status, bool refresh = false}) async {
    if (refresh) {
      _publicHasMore = true;
      _publicQuestions.clear();
    }
    if (_publicHasMore &&
        mainCubit.state.internetConnectionIsAvailable &&
        (status ?? cacheManager.getUserStatus()?.status) ==
            FortunicaUserStatus.live) {
      _lastId = _publicQuestions.lastOrNull?.id;
      String? filtersLanguage;
      if (state.userMarkets.isNotEmpty) {
        final MarketsType marketsType =
            state.userMarkets[state.currentMarketIndexForPublic];
        filtersLanguage =
            marketsType != MarketsType.all ? marketsType.name : null;
      }

      final QuestionsListResponse result = await _repository.getPublicQuestions(
          limit: questionsLimit,
          lastId: _lastId,
          filtersLanguage: filtersLanguage);
      _publicHasMore = result.hasMore ?? true;

      _publicQuestions.addAll(result.questions ?? const []);

      emit(state.copyWith(publicQuestions: List.of(_publicQuestions)));
    }
  }

  Future<void> getPrivateQuestions(
      {FortunicaUserStatus? status, bool refresh = false}) async {
    if (refresh) {
      _historyHasMore = true;
      _historyPage = 1;
      _privateQuestionsWithHistory.clear();
    }
    if (mainCubit.state.internetConnectionIsAvailable &&
        (status ?? cacheManager.getUserStatus()?.status) ==
            FortunicaUserStatus.live) {
      String? filtersLanguage;
      if (state.userMarkets.isNotEmpty) {
        final MarketsType marketsType =
            state.userMarkets[state.currentMarketIndexForPrivate];
        filtersLanguage =
            marketsType != MarketsType.all ? marketsType.name : null;
      }

      final ChatItemType questionsType = filters[state.currentFilterIndex];
      final String? filterName = questionsType != ChatItemType.all
          ? questionsType.filterTypeName
          : null;

      final QuestionsListResponse result =
          await _repository.getPrivateQuestions(
        filtersLanguage: filtersLanguage,
        filtersType: filterName,
      );

      _privateQuestionsWithHistory.addAll(result.questions ?? const []);

      await getHistoryList(
        status: status,
        isFirstRequest: true,
      );

      emit(
        state.copyWith(
          privateQuestionsWithHistory: List.of(
            _privateQuestionsWithHistory,
          ),
        ),
      );
    }
  }

  Future<void> getHistoryList(
      {FortunicaUserStatus? status, isFirstRequest = false}) async {
    if (_historyHasMore &&
        mainCubit.state.internetConnectionIsAvailable &&
        (status ?? cacheManager.getUserStatus()?.status) ==
            FortunicaUserStatus.live) {
      final QuestionsListResponse result = await _repository.getHistoryList(
        limit: questionsLimit,
        page: _historyPage++,
      );

      _historyHasMore = result.hasMore ?? true;

      _privateQuestionsWithHistory.addAll(result.questions ?? const []);

      if (!isFirstRequest) {
        emit(
          state.copyWith(
            privateQuestionsWithHistory: List.of(
              _privateQuestionsWithHistory,
            ),
          ),
        );
      }
    }
  }
}
