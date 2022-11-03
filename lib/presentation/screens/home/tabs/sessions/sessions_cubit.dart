import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/data/cache/caching_manager.dart';
import 'package:shared_advisor_interface/data/models/user_info/fortunica_user_status.dart';
import 'package:shared_advisor_interface/data/network/responses/questions_list_response.dart';
import 'package:shared_advisor_interface/domain/repositories/sessions_repository.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/sessions/sessions_state.dart';

class SessionsCubit extends Cubit<SessionsState> {
  final ChatsRepository _repository = Get.find<ChatsRepository>();
  final CachingManager cacheManager;
  final ScrollController controller = ScrollController();
  final MainCubit mainCubit = Get.find<MainCubit>();
  late final VoidCallback disposeListen;

  String? lastId;
  bool hasMore = true;

  SessionsCubit(this.cacheManager) : super(const SessionsState()) {
    controller.addListener(addScrollControllerListener);
    disposeListen = cacheManager.listenCurrentUserStatus((value) {
      getListOfQuestions(
        state.currentOptionIndex,
        status: value.status,
      );
    });
    getListOfQuestions(state.currentOptionIndex);
    emit(state.copyWith(
        currentOptionIndex: Get.arguments['sessionScreenTab'] as int? ?? 0));
  }

  @override
  Future<void> close() async {
    controller.dispose();
    return super.close();
  }

  void addScrollControllerListener() async {
    if (!mainCubit.state.isLoading && controller.position.extentAfter <= 0) {
      await getListOfQuestions(state.currentOptionIndex);
    }
  }

  void changeFilterIndex(int newIndex) {
    emit(state.copyWith(selectedFilterIndex: newIndex));
  }

  Future<void> getListOfQuestions(int index,
      {FortunicaUserStatus? status}) async {
    if (mainCubit.state.internetConnectionIsAvailable &&
        (status ?? cacheManager.getUserStatus()?.status) ==
            FortunicaUserStatus.live) {
      resetList(index);
      if (!hasMore) return;
      QuestionsListResponse result =
          QuestionsListResponse(questions: state.questions, lastId: lastId);
      hasMore = result.hasMore ?? true;
      lastId = (result.questions ?? const []).lastOrNull?.id;
      if (state.questions.isEmpty) {
        result = await _repository.getListOfQuestions(
            lastId: lastId, isPublicFilter: state.currentOptionIndex == 0);
        emit(state.copyWith(questions: result.questions ?? const []));
        return;
      }
      result = await _repository.getListOfQuestions(
          lastId: lastId, isPublicFilter: state.currentOptionIndex == 0);
      final questions = List.of(state.questions)
        ..addAll(result.questions ?? const []);

      emit(state.copyWith(questions: questions));
    }
  }

  void resetList(int index) {
    if (index != state.currentOptionIndex) {
      lastId = null;
      hasMore = true;
      emit(
        state.copyWith(
          currentOptionIndex: index,
          questions: const [],
        ),
      );
    }
  }
}
