import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/data/cache/caching_manager.dart';
import 'package:shared_advisor_interface/data/models/chats/chat_item.dart';
import 'package:shared_advisor_interface/data/models/customer_info/customer_info.dart';
import 'package:shared_advisor_interface/data/models/enums/chat_item_type.dart';
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

  final List<ChatItemType> filters = [
    ChatItemType.all,
    ChatItemType.ritual,
    ChatItemType.private,
  ];

  final List<ChatItem> _customerSessions = [];
  final MainCubit _mainCubit = getIt.get<MainCubit>();
  final ChatsRepository _chatsRepository = getIt.get<ChatsRepository>();
  final CustomerRepository _customerRepository =
      getIt.get<CustomerRepository>();
  final ScrollController questionsController = ScrollController();
  final ConnectivityService _connectivityService = ConnectivityService();

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
    argumentsQuestion = Get.arguments as ChatItem;

    emit(state.copyWith(
        clientName: argumentsQuestion.clientName,
        zodiacSign: argumentsQuestion.clientInformation?.zodiac));
    getCustomerInfo();
    if (argumentsQuestion.clientID != null) {
      getCustomerSessions();
    }

    questionsController.addListener(() async {
      if (!_mainCubit.state.isLoading &&
          questionsController.position.extentAfter <= _screenHeight) {
        await getCustomerSessions();
      }
    });

    _updateSessionsSubscription = _mainCubit.sessionsUpdateTrigger.listen(
      (value) async {
        await refreshCustomerSessions();
      },
    );
  }

  @override
  Future<void> close() async {
    questionsController.dispose();
    _updateSessionsSubscription.cancel();
    return super.close();
  }

  void changeFilterIndex(int newIndex) {
    emit(state.copyWith(currentFilterIndex: newIndex));
    refreshCustomerSessions();
  }

  Future<void> getCustomerSessions({bool refresh = false}) async {
    if (!_isLoading) {
      _isLoading = true;
      try {
        if (refresh) {
          _hasMore = true;
          _lastItem = null;
          _customerSessions.clear();
        }
        if (_hasMore && await _connectivityService.checkConnection()) {
          final ChatItemType questionsType = filters[state.currentFilterIndex];
          final String? filterType = questionsType != ChatItemType.all
              ? questionsType.filterTypeName
              : null;

          final QuestionsListResponse result =
              await _chatsRepository.getCustomerSessions(
                  id: argumentsQuestion.clientID ?? '',
                  limit: AppConstants.questionsLimit,
                  lastItem: _lastItem,
                  filterType: filterType);
          _hasMore = result.hasMore ?? true;
          _lastItem = result.lastItem;

          _customerSessions.addAll(result.questions ?? const []);
          emit(state.copyWith(
            customerSessions: List.of(_customerSessions),
          ));
        }
      } on DioError catch (e) {
        if (e.response?.statusCode == 409) {
          _showErrorAlert();
          logger.d(e);
        }
      }
      _isLoading = false;
    }
  }

  Future<void> getCustomerInfo() async {
    if (argumentsQuestion.clientID != null) {
      CustomerInfo customerInfo = await _customerRepository
          .getCustomerInfo(argumentsQuestion.clientID ?? '');
      emit(
        state.copyWith(
            clientName: '${customerInfo.firstName} ${customerInfo.lastName}',
            zodiacSign: customerInfo.zodiac),
      );
    }
  }

  void goToChat(ChatItem question) {
    if (argumentsQuestion.clientID != null) {
      if (question.hasUnanswered != null && !question.hasUnanswered!) {
        Get.toNamed(
          AppRoutes.chat,
          arguments: ChatScreenArguments(
            clientId: argumentsQuestion.clientID,
            storyIdForHistory: question.id,
            question: question.copyWith(
              clientID: argumentsQuestion.clientID,
              clientName: argumentsQuestion.clientName,
              clientInformation: argumentsQuestion.clientInformation,
            ),
          ),
        );
      } else if (question.hasUnanswered != null && question.hasUnanswered!) {
        // Get.toNamed(
        //   AppRoutes.chat,
        //   arguments: ChatScreenArguments(
        //     clientId: argumentsQuestion.clientID,
        //     storyId: question.id,
        //     ritualId: question.ritualId,
        //     question: question.copyWith(
        //       clientID: argumentsQuestion.clientID,
        //       clientName: argumentsQuestion.clientName,
        //       clientInformation: argumentsQuestion.clientInformation,
        //     ),
        //   ),
        // );
      }
    }
  }

  Future<void> refreshCustomerSessions() async {
    await getCustomerSessions(refresh: true);
  }
}
