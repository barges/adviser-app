import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/data/cache/caching_manager.dart';
import 'package:shared_advisor_interface/data/models/chats/chat_item.dart';
import 'package:shared_advisor_interface/data/models/customer_info/customer_info.dart';
import 'package:shared_advisor_interface/data/models/enums/chat_item_type.dart';
import 'package:shared_advisor_interface/data/models/enums/markets_type.dart';
import 'package:shared_advisor_interface/data/models/user_info/user_profile.dart';
import 'package:shared_advisor_interface/data/network/responses/questions_list_response.dart';
import 'package:shared_advisor_interface/domain/repositories/chats_repository.dart';
import 'package:shared_advisor_interface/domain/repositories/customer_repository.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/resources/app_arguments.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/resources/app_routes.dart';
import 'package:shared_advisor_interface/presentation/screens/customer_sessions/customer_sessions_state.dart';
import 'package:shared_advisor_interface/presentation/services/connectivity_service.dart';

class CustomerSessionsCubit extends Cubit<CustomerSessionsState> {
  final CachingManager cacheManager;
  final double _screenHeight;
  final VoidCallback _showErrorAlert;

  final MainCubit _mainCubit = getIt.get<MainCubit>();
  final ChatsRepository _chatsRepository = getIt.get<ChatsRepository>();
  final CustomerRepository _customerRepository =
      getIt.get<CustomerRepository>();
  final ScrollController questionsScrollController = ScrollController();
  final ConnectivityService _connectivityService =
      getIt.get<ConnectivityService>();

  final List<ChatItemType> filters = [
    ChatItemType.ritual,
    ChatItemType.private,
  ];

  final List<ChatItem> _privateQuestionsWithHistory = [];
  final List<String> _excludeIds = [];

  late final CustomerSessionsScreenArguments arguments;
  late final ChatItem argumentsQuestion;
  late final StreamSubscription<bool> _updateSessionsSubscription;

  bool _hasMore = true;
  String? _lastItem;
  bool _isLoading = false;

  CustomerSessionsCubit(
    this.cacheManager,
    this._screenHeight,
    this._showErrorAlert,
  ) : super(const CustomerSessionsState()) {
    arguments = Get.arguments as CustomerSessionsScreenArguments;
    argumentsQuestion = arguments.question;

    getUserMarkets();

    emit(
      state.copyWith(
        currentMarketIndex: arguments.marketIndex,
        clientName: argumentsQuestion.clientName,
        zodiacSign: argumentsQuestion.clientInformation?.zodiac,
      ),
    );

    getData();

    questionsScrollController.addListener(() {
      if (questionsScrollController.position.extentAfter <= _screenHeight &&
          !_isLoading) {
        getCustomerHistoryStories(
          excludeIds: _excludeIds,
        );
      }
    });

    _updateSessionsSubscription = _mainCubit.sessionsUpdateTrigger.listen(
      (value) async {
        getPrivateQuestions(refresh: true);
      },
    );
  }

  @override
  Future<void> close() async {
    questionsScrollController.dispose();
    _updateSessionsSubscription.cancel();
    return super.close();
  }

  Future<void> getData() async {
    if (argumentsQuestion.clientID != null) {
      getCustomerInfo();
      getPrivateQuestions();
    }
  }

  void closeErrorWidget() {
    _mainCubit.clearErrorMessage();
  }

  void getUserMarkets() {
    final UserProfile? userProfile = cacheManager.getUserProfile();
    final List<MarketsType> userMarkets = [
      MarketsType.all,
      ...userProfile?.activeLanguages ?? [],
    ];
    emit(state.copyWith(userMarkets: userMarkets));
  }

  void changeFilterIndex(int? newIndex) {
    emit(state.copyWith(currentFilterIndex: newIndex));
    getPrivateQuestions(refresh: true);
  }

  void changeMarketIndex(int newIndex) {
    emit(state.copyWith(currentMarketIndex: newIndex));
    getPrivateQuestions(refresh: true);
  }

  Future<void> getPrivateQuestions({bool refresh = false}) async {
    if (refresh) {
      _privateQuestionsWithHistory.clear();
      _excludeIds.clear();
      _hasMore = true;
      _lastItem = null;
    }

    _isLoading = true;

    if (await _connectivityService.checkConnection()) {
      try {
        final ChatItemType? questionsType = state.currentFilterIndex != null
            ? filters[state.currentFilterIndex!]
            : null;
        final String? filterType = questionsType?.filterTypeName;
        String? filtersLanguage;
        if (state.userMarkets.isNotEmpty) {
          final MarketsType marketsType =
              state.userMarkets[state.currentMarketIndex];
          filtersLanguage =
              marketsType != MarketsType.all ? marketsType.name : null;
        }
        final QuestionsListResponse result =
            await _chatsRepository.getCustomerQuestions(
          clientId: argumentsQuestion.clientID ?? '',
          filterType: filterType,
          filterLanguage: filtersLanguage,
        );

        final List<ChatItem> activeQuestions = [];
        final List<String> excludeIds = [];

        for (ChatItem question in result.questions ?? []) {
          activeQuestions.add(question.copyWith(isActive: true));
          if (question.type == ChatItemType.ritual &&
              question.ritualID != null) {
            excludeIds.add(question.ritualID!);
          }
        }

        _privateQuestionsWithHistory.addAll(activeQuestions);

        _excludeIds.addAll(excludeIds);
        _isLoading = false;
        await getCustomerHistoryStories(
          excludeIds: excludeIds,
          refresh: refresh,
        );
      } on DioError catch (e) {
        if (e.response?.statusCode == 409) {
          _showErrorAlert();
        }
        logger.d(e);
      } finally {
        _isLoading = false;
      }
    } else {
      _isLoading = false;
    }
  }

  Future<void> getCustomerHistoryStories({
    required List<String> excludeIds,
    bool refresh = false,
  }) async {
    if (_hasMore) {
      _isLoading = true;

      if (await _connectivityService.checkConnection()) {
        try {
          final ChatItemType? questionsType = state.currentFilterIndex != null
              ? filters[state.currentFilterIndex!]
              : null;
          final String? filterType = questionsType?.filterTypeName;

          String? filtersLanguage;
          if (state.userMarkets.isNotEmpty) {
            final MarketsType marketsType =
                state.userMarkets[state.currentMarketIndex];
            filtersLanguage =
                marketsType != MarketsType.all ? marketsType.name : null;
          }

          final QuestionsListResponse result =
              await _chatsRepository.getCustomerHistoryStories(
            id: argumentsQuestion.clientID ?? '',
            limit: AppConstants.questionsLimit,
            lastItem: _lastItem,
            filterType: filterType,
            filterLanguage: filtersLanguage,
            excludeIds: excludeIds.isNotEmpty ? excludeIds.join(',') : null,
          );
          _hasMore = result.hasMore ?? true;
          _lastItem = result.lastItem;

          _privateQuestionsWithHistory.addAll(result.questions ?? const []);

          emit(
            state.copyWith(
              privateQuestionsWithHistory: List.of(
                _privateQuestionsWithHistory,
              ),
            ),
          );
        } on DioError catch (e) {
          if (e.response?.statusCode == 409) {
            _showErrorAlert();
          }
          logger.d(e);
        } finally {
          _isLoading = false;
        }
      }
      _isLoading = false;
    }
    _isLoading = false;
    if (refresh && state.privateQuestionsWithHistory?.isNotEmpty == true) {
      scrollListUp();
    }
  }

  void scrollListUp() {
    SchedulerBinding.instance.endOfFrame.then((value) =>
        questionsScrollController.animateTo(0.0,
            duration: const Duration(milliseconds: 500), curve: Curves.ease));
  }

  Future<void> getCustomerInfo() async {
    CustomerInfo customerInfo = await _customerRepository
        .getCustomerInfo(argumentsQuestion.clientID ?? '');

    final String? firstName = customerInfo.firstName;
    final String? lastName = customerInfo.lastName;
    emit(
      state.copyWith(
          clientName: firstName != null && lastName != null
              ? '$firstName $lastName'
              : null,
          zodiacSign: customerInfo.zodiac),
    );
  }

  void goToChat(ChatItem question) {
    if (argumentsQuestion.clientID != null) {
      if (question.isActive) {
        Get.toNamed(
          AppRoutes.chat,
          arguments: ChatScreenArguments(
            privateQuestionId: question.id,
            ritualID: question.ritualID,
            question: question.copyWith(
              clientID: argumentsQuestion.clientID,
              clientName: argumentsQuestion.clientName,
              clientInformation: argumentsQuestion.clientInformation,
            ),
          ),
        );
      } else {
        Get.toNamed(
          AppRoutes.chat,
          arguments: ChatScreenArguments(
            storyIdForHistory: question.id,
            question: question.copyWith(
              clientID: argumentsQuestion.clientID,
              clientName: argumentsQuestion.clientName,
              clientInformation: argumentsQuestion.clientInformation,
            ),
          ),
        );
      }
    }
  }
}
