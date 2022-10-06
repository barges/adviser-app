import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/data/models/error_model.dart';
import 'package:shared_advisor_interface/data/network/responses/questions_list_response.dart';
import 'package:shared_advisor_interface/domain/repositories/sessions_repository.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/sessions/sessions_state.dart';

class SessionsCubit extends Cubit<SessionsState> {
  final SessionsRepository _repository;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  final ScrollController controller = ScrollController();

  SessionsCubit(this._repository) : super(const SessionsState()) {
    controller.addListener(addScrollControllerListener);
    getListOfQuestions(state.currentOptionIndex);
  }

  @override
  Future<void> close() async {
    controller.dispose();
    return super.close();
  }

  void addScrollControllerListener() {
    if (controller.offset >= (controller.position.maxScrollExtent * 0.9)) {
      getListOfQuestions(state.currentOptionIndex);
    }
  }

  void changeFilterIndex(int newIndex) {
    emit(state.copyWith(selectedFilterIndex: newIndex));
  }

  Future<void> getListOfQuestions(int index) async {
    resetList(index);
    if (!state.hasMore) return;
    try {
      QuestionsListResponse result =
          QuestionsListResponse(questions: state.questions);
      final int page = result.questions?.length ?? 0;
      emit(state.copyWith(hasMore: result.hasMore ?? true, page: page));
      if (state.questions.isEmpty) {
        result = await run(_repository.getListOfQuestions(
            page: page, isPublicFilter: state.currentOptionIndex == 0));

        return emit(state.copyWith(
            questions: result.questions ?? const [],
            hasMore: state.hasMore,
            page: page));
      }

      result = await run(_repository.getListOfQuestions(
          page: page, isPublicFilter: state.currentOptionIndex == 0));
      final questions = List.of(state.questions)
        ..addAll(result.questions ?? const []);

      emit(state.copyWith(
        questions: questions,
        hasMore: state.hasMore,
        page: state.questions.length - page,
      ));
    } catch (e) {
      emit(state.copyWith(error: errorMessageAdapter(e)));
    }
  }

  void resetList(int index) {
    if (index != state.currentOptionIndex) {
      emit(state.copyWith(
          currentOptionIndex: index,
          hasMore: true,
          questions: const [],
          page: 0));
    }
  }
}
