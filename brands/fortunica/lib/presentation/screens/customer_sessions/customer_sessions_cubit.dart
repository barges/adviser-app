import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortunica/data/cache/fortunica_caching_manager.dart';
import 'package:fortunica/data/models/chats/chat_item.dart';
import 'package:fortunica/data/models/customer_info/customer_info.dart';
import 'package:fortunica/data/models/enums/chat_item_type.dart';
import 'package:fortunica/data/models/enums/markets_type.dart';
import 'package:fortunica/data/models/user_info/user_profile.dart';
import 'package:fortunica/data/network/responses/questions_list_response.dart';
import 'package:fortunica/domain/repositories/fortunica_chats_repository.dart';
import 'package:fortunica/domain/repositories/fortunica_customer_repository.dart';
import 'package:fortunica/fortunica_constants.dart';
import 'package:fortunica/fortunica_main_cubit.dart';
import 'package:fortunica/presentation/screens/chat/chat_screen.dart';
import 'package:fortunica/presentation/screens/customer_sessions/customer_sessions_screen.dart';
import 'package:fortunica/presentation/screens/customer_sessions/customer_sessions_state.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.gr.dart';
import 'package:shared_advisor_interface/services/connectivity_service.dart';

class CustomerSessionsCubit extends Cubit<CustomerSessionsState> {
  final FortunicaCachingManager cacheManager;
  final double screenHeight;
  final VoidCallback showErrorAlert;
  final CustomerSessionsScreenArguments arguments;

  final FortunicaMainCubit mainCubit;
  final FortunicaChatsRepository chatsRepository;
  final FortunicaCustomerRepository customerRepository;

  final ConnectivityService connectivityService;

  final List<ChatItemType> filters = [
    ChatItemType.ritual,
    ChatItemType.private,
  ];

  final ScrollController questionsScrollController = ScrollController();
  final List<ChatItem> _privateQuestionsWithHistory = [];
  final List<String> _excludeIds = [];

  late final ChatItem argumentsQuestion;
  late final StreamSubscription<bool> _updateSessionsSubscription;

  bool _hasMore = true;
  String? _lastItem;
  bool _isLoading = false;

  CustomerSessionsCubit({
    required this.chatsRepository,
    required this.customerRepository,
    required this.connectivityService,
    required this.arguments,
    required this.mainCubit,
    required this.cacheManager,
    required this.screenHeight,
    required this.showErrorAlert,
  }) : super(const CustomerSessionsState()) {
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
      if (questionsScrollController.position.extentAfter <= screenHeight &&
          !_isLoading) {
        getCustomerHistoryStories(
          excludeIds: _excludeIds,
        );
      }
    });

    _updateSessionsSubscription = mainCubit.sessionsUpdateTrigger.listen(
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
    mainCubit.clearErrorMessage();
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

    if (await connectivityService.checkConnection()) {
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
            await chatsRepository.getCustomerQuestions(
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
          showErrorAlert();
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

      if (await connectivityService.checkConnection()) {
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
              await chatsRepository.getCustomerHistoryStories(
            id: argumentsQuestion.clientID ?? '',
            limit: FortunicaConstants.questionsLimit,
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
            showErrorAlert();
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
    CustomerInfo customerInfo = await customerRepository
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

  void goToChat(BuildContext context, ChatItem question) {
    if (argumentsQuestion.clientID != null) {
      if (question.isActive) {
        context.push(
          route: FortunicaChat(
            chatScreenArguments: ChatScreenArguments(
              privateQuestionId: question.id,
              ritualID: question.ritualID,
              question: question.copyWith(
                clientID: argumentsQuestion.clientID,
                clientName: argumentsQuestion.clientName,
                clientInformation: argumentsQuestion.clientInformation,
              ),
            ),
          ),
        );
      } else {
        context.push(
          route: FortunicaChat(
            chatScreenArguments: ChatScreenArguments(
              storyIdForHistory: question.id,
              question: question.copyWith(
                clientID: argumentsQuestion.clientID,
                clientName: argumentsQuestion.clientName,
                clientInformation: argumentsQuestion.clientInformation,
              ),
            ),
          ),
        );
      }
    }
  }
}
