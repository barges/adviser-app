import 'dart:async';

import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.gr.dart';
import 'package:shared_advisor_interface/services/connectivity_service.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortunica/data/cache/fortunica_caching_manager.dart';
import 'package:fortunica/data/models/app_success/app_success.dart';
import 'package:fortunica/data/models/app_success/ui_success_type.dart';
import 'package:fortunica/data/models/chats/chat_item.dart';
import 'package:fortunica/data/models/enums/chat_item_status_type.dart';
import 'package:fortunica/data/models/enums/fortunica_user_status.dart';
import 'package:fortunica/data/models/enums/markets_type.dart';
import 'package:fortunica/data/models/user_info/user_status.dart';
import 'package:fortunica/data/network/requests/answer_request.dart';
import 'package:fortunica/data/network/responses/questions_list_response.dart';
import 'package:fortunica/domain/repositories/fortunica_chats_repository.dart';
import 'package:fortunica/fortunica_main_cubit.dart';
import 'package:fortunica/presentation/screens/chat/chat_screen.dart';
import 'package:fortunica/presentation/screens/customer_profile/customer_profile_screen.dart';
import 'package:fortunica/presentation/screens/customer_sessions/customer_sessions_screen.dart';
import 'package:fortunica/presentation/screens/home/tabs/sessions/sessions_state.dart';

class SessionsCubit extends Cubit<SessionsState> {
  final FortunicaCachingManager cacheManager;

  final ScrollController publicQuestionsScrollController = ScrollController();
  final ScrollController conversationsScrollController = ScrollController();
  final FortunicaMainCubit mainCubit;
  final FortunicaChatsRepository chatsRepository;
  final ConnectivityService connectivityService;

  late final StreamSubscription<bool> _updateSessionsSubscription;
  late final StreamSubscription _userStatusSubscription;
  late final StreamSubscription _userProfileSubscription;
  final double screenHeight;

  final List<ChatItem> _publicQuestions = [];
  final List<ChatItem> _conversationsList = [];

  UserStatus? previousStatus;

  String? _lastId;
  bool _publicHasMore = true;
  String? _conversationsLastItem;
  bool _conversationsHasMore = true;
  bool _isPublicLoading = false;
  bool _isConversationsLoading = false;

  SessionsCubit({
   required this.cacheManager,
    required this.screenHeight,
    required  this.connectivityService,
    required this.chatsRepository,
    required this.mainCubit,
  }) : super(const SessionsState()) {
    emit(state.copyWith(userMarkets: [MarketsType.all]));

    publicQuestionsScrollController.addListener(() {
      if (!_isPublicLoading &&
          publicQuestionsScrollController.position.extentAfter <=
              screenHeight) {
        getPublicQuestions();
      }
    });
    conversationsScrollController.addListener(() {
      if (!_isConversationsLoading &&
          conversationsScrollController.position.extentAfter <=
              screenHeight) {
        getConversations();
      }
    });
    _userStatusSubscription =
        cacheManager.listenCurrentUserStatusStream((value) {
      if (previousStatus != value) {
        previousStatus = value;
        getQuestions(
          status: value.status,
        );
      }
    });
    _userProfileSubscription =
        cacheManager.listenUserProfileStream((userProfile) {
      final List<MarketsType> userMarkets = [
        MarketsType.all,
        ...userProfile.activeLanguages ?? [],
      ];
      emit(state.copyWith(userMarkets: userMarkets));
    });

    _updateSessionsSubscription = mainCubit.sessionsUpdateTrigger.listen(
      (value) {
        getQuestions().then((value) => SchedulerBinding.instance.endOfFrame
            .then((value) => publicQuestionsScrollController.jumpTo(0.0)));
      },
    );
  }

  @override
  Future<void> close() async {
    publicQuestionsScrollController.dispose();
    conversationsScrollController.dispose();
    _updateSessionsSubscription.cancel();
    _userProfileSubscription.cancel();
    _userStatusSubscription.cancel();
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
    chatsRepository.takeQuestion(AnswerRequest(questionID: questionId));
  }

  void goToCustomerProfile(BuildContext context, ChatItem question) {
    if (question.clientID != null || question.id != null) {
      context.push(
        route: FortunicaCustomerProfile(
          customerProfileScreenArguments: CustomerProfileScreenArguments(
            customerID: question.clientID ?? question.id!,
            clientName: question.clientName,
            zodiacSign: question.clientInformation?.zodiac,
          ),
        ),
      );
    }
  }

  Future<void> goToChatForPublic(BuildContext context, ChatItem question) async {
    if (question.clientID != null) {
      context.push(
        route: FortunicaChat(
          chatScreenArguments: ChatScreenArguments(
            question: question,
            publicQuestionId: question.id,
          ),
        ),
      );
    }
  }

  void goToCustomerSessions(BuildContext context, ChatItem question) {
    context.push(
      route: FortunicaCustomerSessions(
        customerSessionsScreenArguments: CustomerSessionsScreenArguments(
            question: question,
            marketIndex: state.currentMarketIndexForPrivate),
      ),
    );
  }

  void clearSuccessMessage() {
    if (state.appSuccess is! EmptySuccess) {
      emit(
        state.copyWith(
          appSuccess: const EmptySuccess(),
        ),
      );
    }
  }

  void closeErrorWidget() {
    mainCubit.clearErrorMessage();
  }

  Future<void> getPublicQuestions(
      {FortunicaUserStatus? status, bool refresh = false}) async {
    if (!_isPublicLoading) {
      _isPublicLoading = true;
      try {
        if (refresh) {
          _publicHasMore = true;
          _publicQuestions.clear();
        }
        if (_publicHasMore &&
            await connectivityService.checkConnection() &&
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

          final QuestionsListResponse result =
              await chatsRepository.getPublicQuestions(
                  limit: AppConstants.questionsLimit,
                  lastId: _lastId,
                  filtersLanguage: filtersLanguage);
          _publicHasMore = result.hasMore ?? true;

          _publicQuestions.addAll(result.questions ?? const []);

          if (_publicQuestions.firstOrNull?.status ==
              ChatItemStatusType.taken) {
            emit(state.copyWith(
              publicQuestions: List.of(_publicQuestions),
              disabledIndexes: [1],
              appSuccess: UISuccess(UISuccessMessagesType
                  .youMustAnswerYourActivePublicQuestionBeforeYouCanHelpSomeoneElse),
            ));
          } else {
            emit(state.copyWith(
              publicQuestions: List.of(_publicQuestions),
              disabledIndexes: [],
              appSuccess: const EmptySuccess(),
            ));
          }
        }
      } catch (e) {
        logger.d(e);
      } finally {
        _isPublicLoading = false;
      }
    }
  }

  Future<void> getConversations(
      {FortunicaUserStatus? status, bool refresh = false}) async {
    if (!_isConversationsLoading) {
      _isConversationsLoading = true;
      try {
        if (refresh) {
          _conversationsHasMore = true;
          _conversationsLastItem = null;
          _conversationsList.clear();
        }
        if (_conversationsHasMore &&
            await connectivityService.checkConnection() &&
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
              await chatsRepository.getConversationsList(
            limit: AppConstants.questionsLimit,
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
      } catch (e) {
        logger.d(e);
      } finally {
        _isConversationsLoading = false;
      }
    }
  }
}
