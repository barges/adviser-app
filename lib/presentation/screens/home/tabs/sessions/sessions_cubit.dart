import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../infrastructure/routing/app_router.dart';
import '../../../../../data/cache/fortunica_caching_manager.dart';
import '../../../../../data/models/app_success/app_success.dart';
import '../../../../../data/models/app_success/ui_success_type.dart';
import '../../../../../data/models/chats/chat_item.dart';
import '../../../../../data/models/enums/chat_item_status_type.dart';
import '../../../../../data/models/enums/fortunica_user_status.dart';
import '../../../../../data/models/enums/markets_type.dart';
import '../../../../../data/models/user_info/user_status.dart';
import '../../../../../data/network/requests/answer_request.dart';
import '../../../../../data/network/responses/questions_list_response.dart';
import '../../../../../domain/repositories/fortunica_chats_repository.dart';
import '../../../../../fortunica_constants.dart';
import '../../../../../global.dart';
import '../../../../../infrastructure/routing/app_router.gr.dart';
import '../../../../../main_cubit.dart';
import '../../../../../services/connectivity_service.dart';
import '../../../chat/chat_screen.dart';
import '../../../customer_profile/customer_profile_screen.dart';
import '../../../customer_sessions/customer_sessions_screen.dart';
import 'sessions_state.dart';

class SessionsCubit extends Cubit<SessionsState> {
  final FortunicaCachingManager cacheManager;

  final MainCubit mainCubit;
  final FortunicaChatsRepository chatsRepository;
  final ConnectivityService connectivityService;

  late final StreamSubscription _userStatusSubscription;
  late final StreamSubscription _userProfileSubscription;

  final List<ChatItem> _publicQuestions = [];
  final List<ChatItem> _conversationsList = [];

  UserStatus? previousStatus;

  String? _lastId;
  bool _publicHasMore = true;
  String? _conversationsLastItem;
  bool _conversationsHasMore = true;
  bool isPublicLoading = false;
  bool isConversationsLoading = false;

  SessionsCubit({
    required this.cacheManager,
    required this.connectivityService,
    required this.chatsRepository,
    required this.mainCubit,
  }) : super(const SessionsState()) {
    emit(state.copyWith(userMarkets: [MarketsType.all]));

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
  }

  @override
  Future<void> close() async {
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

  Future<void> goToChatForPublic(
      BuildContext context, ChatItem question) async {
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
    if (!isPublicLoading) {
      isPublicLoading = true;
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
                  limit: FortunicaConstants.questionsLimit,
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
        isPublicLoading = false;
      }
    }
  }

  Future<void> getConversations(
      {FortunicaUserStatus? status, bool refresh = false}) async {
    if (!isConversationsLoading) {
      isConversationsLoading = true;
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
            limit: FortunicaConstants.questionsLimit,
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
        isConversationsLoading = false;
      }
    }
  }
}
