import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/data/cache/caching_manager.dart';
import 'package:shared_advisor_interface/data/models/chats/chat_item.dart';
import 'package:shared_advisor_interface/data/models/enums/chat_item_status_type.dart';
import 'package:shared_advisor_interface/data/models/enums/fortunica_user_status.dart';
import 'package:shared_advisor_interface/data/models/enums/markets_type.dart';
import 'package:shared_advisor_interface/data/models/user_info/user_status.dart';
import 'package:shared_advisor_interface/data/network/requests/answer_request.dart';
import 'package:shared_advisor_interface/data/network/responses/questions_list_response.dart';
import 'package:shared_advisor_interface/domain/repositories/chats_repository.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/resources/app_arguments.dart';
import 'package:shared_advisor_interface/presentation/resources/app_routes.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/sessions/sessions_state.dart';

const int questionsLimit = 20;

class SessionsCubit extends Cubit<SessionsState> {
  final ChatsRepository _repository = getIt.get<ChatsRepository>();
  final CachingManager cacheManager;
  final ScrollController publicQuestionsController = ScrollController();
  final ScrollController conversationsController = ScrollController();
  final MainCubit _mainCubit = getIt.get<MainCubit>();
  late final StreamSubscription<bool> _updateSessionsSubscription;
  late final VoidCallback disposeUserStatusListen;
  late final VoidCallback disposeUserProfileListen;
  final BuildContext context;

  final List<ChatItem> _publicQuestions = [];
  final List<ChatItem> _conversationsList = [];

  UserStatus? previousStatus;

  String? _lastId;
  bool _publicHasMore = true;
  String? _conversationsLastItem;
  bool _conversationsHasMore = true;

  SessionsCubit(this.cacheManager, this.context)
      : super(const SessionsState()) {
    publicQuestionsController.addListener(() async {
      if (!_mainCubit.state.isLoading &&
          publicQuestionsController.position.extentAfter <=
              MediaQuery.of(context).size.height) {
        await getPublicQuestions();
      }
    });
    conversationsController.addListener(() async {
      if (!_mainCubit.state.isLoading &&
          conversationsController.position.extentAfter <=
              MediaQuery.of(context).size.height) {
        await getConversations();
      }
    });
    disposeUserStatusListen = cacheManager.listenCurrentUserStatus((value) {
      if (previousStatus != value) {
        previousStatus = value;
        getQuestions(
          status: value.status,
        );
      }
    });
    disposeUserProfileListen = cacheManager.listenUserProfile((userProfile) {
      final List<MarketsType> userMarkets = [
        MarketsType.all,
        ...userProfile.activeLanguages ?? [],
      ];
      emit(state.copyWith(userMarkets: userMarkets));
    });

    _updateSessionsSubscription = _mainCubit.sessionsUpdateTrigger.listen(
      (value) {
        getQuestions();
      },
    );
  }

  @override
  Future<void> close() async {
    publicQuestionsController.dispose();
    conversationsController.dispose();
    _updateSessionsSubscription.cancel();
    disposeUserProfileListen.call();
    disposeUserStatusListen.call();
    return super.close();
  }

  Future<void> getQuestions({
    FortunicaUserStatus? status,
  }) async {
    await getPublicQuestions(
      status: status,
      refresh: true,
    );
    if (state.disabledIndexes.isEmpty) {
      getConversations(
        status: status,
        refresh: true,
      );
    }
  }

  void changeMarketIndexForPublic(int newIndex) {
    emit(state.copyWith(currentMarketIndexForPublic: newIndex));
    getPublicQuestions(refresh: true);
  }

  void changeMarketIndexForPrivate(int newIndex) {
    emit(state.copyWith(currentMarketIndexForPrivate: newIndex));
    getConversations(refresh: true);
  }

  void changeCurrentOptionIndex(int newIndex) {
    emit(state.copyWith(currentOptionIndex: newIndex));
  }

  void openSearch() {
    emit(state.copyWith(searchIsOpen: true));
  }

  void closeSearch() {
    emit(state.copyWith(searchIsOpen: false));
  }

  void takeQuestion(String questionId) {
    _repository.takeQuestion(AnswerRequest(questionID: questionId));
  }

  void goToCustomerProfile(ChatItem question) {
    if (question.clientID != null && question.clientName != null) {
      Get.toNamed(
        AppRoutes.customerProfile,
        arguments: CustomerProfileScreenArguments(
          customerID: question.clientID!,
          clientName: question.clientName!,
          zodiacSign: question.clientInformation?.zodiac,
        ),
      );
    }
  }

  Future<void> goToChat(ChatItem question) async {
    Get.toNamed(AppRoutes.chat, arguments: question);
  }

  void clearSuccessMessage() {
    if (state.showSuccessMessage) {
      emit(
        state.copyWith(
          showSuccessMessage: false,
        ),
      );
    }
  }

  Future<void> getPublicQuestions(
      {FortunicaUserStatus? status, bool refresh = false}) async {
    if (refresh) {
      _publicHasMore = true;
      _publicQuestions.clear();
    }
    if (_publicHasMore &&
        _mainCubit.state.internetConnectionIsAvailable &&
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

      if (_publicQuestions.firstOrNull?.status == ChatItemStatusType.taken) {
        emit(state.copyWith(
          publicQuestions: List.of(_publicQuestions),
          disabledIndexes: [1],
          showSuccessMessage: true,
        ));
      } else {
        emit(state.copyWith(
          publicQuestions: List.of(_publicQuestions),
          disabledIndexes: [],
          showSuccessMessage: false,
        ));
      }
    }
  }

  Future<void> getConversations(
      {FortunicaUserStatus? status, bool refresh = false}) async {
    if (refresh) {
      _conversationsHasMore = true;
      _conversationsLastItem = null;
      _conversationsList.clear();
    }
    if (_conversationsHasMore &&
        _mainCubit.state.internetConnectionIsAvailable &&
        (status ?? cacheManager.getUserStatus()?.status) ==
            FortunicaUserStatus.live) {
      String? filtersLanguage;
      if (state.userMarkets.isNotEmpty) {
        final MarketsType marketsType =
            state.userMarkets[state.currentMarketIndexForPrivate];
        filtersLanguage =
            marketsType != MarketsType.all ? marketsType.name : null;
      }

      final QuestionsListResponse result =
          await _repository.getConversationsList(
        limit: questionsLimit,
        filtersLanguage: filtersLanguage,
        lastItem: _conversationsLastItem,
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

// Future<void> getHistoryList(
//     {FortunicaUserStatus? status, isFirstRequest = false}) async {
//   if (_historyHasMore &&
//       _mainCubit.state.internetConnectionIsAvailable &&
//       (status ?? cacheManager.getUserStatus()?.status) ==
//           FortunicaUserStatus.live) {
//     final QuestionsListResponse result = await _repository.getHistoryList(
//       limit: questionsLimit,
//       page: _historyPage++,
//     );
//
//     _historyHasMore = result.hasMore ?? true;
//
//     _privateQuestionsWithHistory.addAll(result.questions ?? const []);
//
//     if (!isFirstRequest) {
//       emit(
//         state.copyWith(
//           privateQuestionsWithHistory: List.of(
//             _privateQuestionsWithHistory,
//           ),
//         ),
//       );
//     }
//   }
// }
}
