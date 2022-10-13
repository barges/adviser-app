import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/data/cache/cache_manager.dart';
import 'package:shared_advisor_interface/data/models/error_model.dart';
import 'package:shared_advisor_interface/data/models/user_info/fortunica_user_status.dart';
import 'package:shared_advisor_interface/data/network/responses/questions_list_response.dart';
import 'package:shared_advisor_interface/domain/repositories/sessions_repository.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/sessions/sessions_state.dart';

class SessionsCubit extends Cubit<SessionsState> {
  final SessionsRepository _repository = Get.find<SessionsRepository>();
  final CacheManager cacheManager;
  final ScrollController controller = ScrollController();
  late final VoidCallback disposeListen;
  final MainCubit mainCubit = Get.find<MainCubit>();

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
  }

  @override
  Future<void> close() async {
    controller.dispose();
    return super.close();
  }

  void addScrollControllerListener() async {
    if (controller.position.extentAfter <= 0 && !mainCubit.state.isLoading) {
      await getListOfQuestions(state.currentOptionIndex);
    }
  }

  void changeFilterIndex(int newIndex) {
    emit(state.copyWith(selectedFilterIndex: newIndex));
  }

  Future<void> getListOfQuestions(int index,
      {FortunicaUserStatusEnum? status}) async {
    if ((status ?? cacheManager.getUserStatus()?.status) ==
        FortunicaUserStatusEnum.live) {
      resetList(index);
      if (!hasMore) return;
      try {
        QuestionsListResponse result =
            QuestionsListResponse(questions: state.questions, lastId: lastId);
        hasMore = result.hasMore ?? true;
        lastId = (result.questions ?? const []).lastOrNull?.id;
        if (state.questions.isEmpty) {
          mainCubit.updateIsLoading(true);
          result = await _repository.getListOfQuestions(
              lastId: lastId, isPublicFilter: state.currentOptionIndex == 0);
          mainCubit.updateIsLoading(false);
          emit(state.copyWith(questions: result.questions ?? const []));
          return;
        }
        mainCubit.updateIsLoading(true);
        result = await _repository.getListOfQuestions(
            lastId: lastId, isPublicFilter: state.currentOptionIndex == 0);
        mainCubit.updateIsLoading(false);
        final questions = List.of(state.questions)
          ..addAll(result.questions ?? const []);

        emit(state.copyWith(questions: questions));
      } catch (e) {
        mainCubit.updateIsLoading(false);
        emit(state.copyWith(error: errorMessageAdapter(e)));
      }
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
