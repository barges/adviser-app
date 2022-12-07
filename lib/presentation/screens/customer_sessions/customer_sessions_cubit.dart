import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/data/cache/caching_manager.dart';
import 'package:shared_advisor_interface/data/models/chats/chat_item.dart';
import 'package:shared_advisor_interface/data/models/customer_info/customer_info.dart';
import 'package:shared_advisor_interface/data/models/enums/chat_item_type.dart';
import 'package:shared_advisor_interface/data/models/enums/fortunica_user_status.dart';
import 'package:shared_advisor_interface/data/network/responses/questions_list_response.dart';
import 'package:shared_advisor_interface/domain/repositories/chats_repository.dart';
import 'package:shared_advisor_interface/domain/repositories/customer_repository.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/ok_cancel_alert.dart';
import 'package:shared_advisor_interface/presentation/resources/app_arguments.dart';
import 'package:shared_advisor_interface/presentation/resources/app_routes.dart';
import 'package:shared_advisor_interface/presentation/screens/customer_sessions/customer_sessions_state.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/sessions/sessions_cubit.dart';

class CustomerSessionsCubit extends Cubit<CustomerSessionsState> {
  final CachingManager cacheManager;
  final BuildContext context;

  final List<ChatItemType> filters = [
    ChatItemType.all,
    ChatItemType.ritual,
    ChatItemType.private,
  ];

  final List<ChatItem> _sessionsQuestions = [];
  final MainCubit _mainCubit = getIt.get<MainCubit>();
  final ChatsRepository _chatsRepository = getIt.get<ChatsRepository>();
  final CustomerRepository _customerRepository =
      getIt.get<CustomerRepository>();
  final ScrollController questionsController = ScrollController();
  late final CustomerSessionsScreenArguments arguments;

  bool _hasMore = true;
  String? _lastItem;

  CustomerSessionsCubit(this.cacheManager, this.context)
      : super(const CustomerSessionsState()) {
    arguments = Get.arguments as CustomerSessionsScreenArguments;

    emit(state.copyWith(
        clientName: arguments.clientName,
        zodiacSign: arguments.clientInformation?.zodiac));
    getCustomerInfo();
    if (arguments.clientId != null) {
      getSessionsQuestions();
    }

    questionsController.addListener(() async {
      if (!_mainCubit.state.isLoading &&
          questionsController.position.extentAfter <=
              MediaQuery.of(context).size.height) {
        await getSessionsQuestions();
      }
    });
  }

  @override
  Future<void> close() async {
    questionsController.dispose();
    return super.close();
  }

  void changeFilterIndex(int newIndex) {
    emit(state.copyWith(currentFilterIndex: newIndex));
    getSessionsQuestions(refresh: true);
  }

  Future<void> getSessionsQuestions(
      {FortunicaUserStatus? status, bool refresh = false}) async {
    try {
      if (refresh) {
        _hasMore = true;
        _sessionsQuestions.clear();
      }
      if (_hasMore &&
          _mainCubit.state.internetConnectionIsAvailable &&
          (status ?? cacheManager.getUserStatus()?.status) ==
              FortunicaUserStatus.live) {
        final ChatItemType questionsType = filters[state.currentFilterIndex];
        final String? filterType = questionsType != ChatItemType.all
            ? questionsType.filterTypeName
            : null;

        final QuestionsListResponse result =
            await _chatsRepository.getSessionQuestions(
                id: arguments.clientId ?? '',
                limit: questionsLimit,
                lastItem: _lastItem,
                filterType: filterType);
        _hasMore = result.hasMore ?? true;
        _lastItem = result.lastItem;

        _sessionsQuestions.addAll(result.questions ?? const []);
        logger.d(_sessionsQuestions);
        emit(state.copyWith(
          sessionsQuestions: List.of(_sessionsQuestions),
        ));
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 409) {
        await showOkCancelAlert(
          context: context,
          title: _mainCubit.state.errorMessage,
          okText: S.of(context).ok,
          actionOnOK: () {
            Get.close(2);
          },
          allowBarrierClock: false,
          isCancelEnabled: false,
        );
        logger.d(e);
      }
    }
  }

  Future<void> getCustomerInfo() async {
    if (arguments.clientId != null) {
      CustomerInfo customerInfo =
          await _customerRepository.getCustomerInfo(arguments.clientId ?? '');
      emit(
        state.copyWith(
            clientName: '${customerInfo.firstName} ${customerInfo.lastName}',
            zodiacSign: customerInfo.zodiac),
      );
    }
  }

  void goToChat(ChatItem question) {
    Get.toNamed(AppRoutes.chat,
        arguments: question.copyWith(
          clientID: arguments.clientId,
          clientName: arguments.clientName,
          clientInformation: arguments.clientInformation,
        ));
  }
}
