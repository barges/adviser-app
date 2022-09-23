import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/data/models/error_model.dart';
import 'package:shared_advisor_interface/data/network/responses/questions_list_response.dart';
import 'package:shared_advisor_interface/domain/repositories/sessions_repository.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/sessions/sessions_state.dart';

class SessionsCubit extends Cubit<SessionsState> {
  final SessionsRepository _repository;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  final ScrollController controller = ScrollController();

  SessionsCubit(this._repository) : super(const SessionsState()) {
    controller.addListener(addScrollControllerListener);
    getListOfQuestions();
  }

  @override
  Future<void> close() async {
    controller.dispose();
    return super.close();
  }

  void addScrollControllerListener() {
    if (controller.offset >= (controller.position.maxScrollExtent * 0.9)) {
      getListOfQuestions();
    }
  }

  void changeFilterIndex(int newIndex) {
    emit(state.copyWith(selectedFilterIndex: newIndex));
  }

  String buildIsPublicText() {
    if (state.isPublic) {
      return S.current.public;
    } else {
      return S.current.forMe;
    }
  }

  Future<void> getListOfQuestions() async {
    if (!state.hasMore) return;
    try {
      QuestionsListResponse result = state.questionsListResponse;
      state.copyWith(hasMore: result.hasMore ?? true, isPublic: state.isPublic);
      if (result.questions?.isEmpty ?? true) {
        emit(state.copyWith(isPublic: true));
        result = await run(_repository.getListOfQuestions(
            page: state.page, isPublicFilter: state.isPublic));

        return emit(state.copyWith(
            questionsListResponse: result,
            hasMore: state.hasMore,
            page: result.questions?.length ?? 0));
      }

      emit(state.copyWith(isPublic: !state.isPublic));

      result = await run(_repository.getListOfQuestions(
          page: state.page, isPublicFilter: state.isPublic));
      final questions =
          List.of(state.questionsListResponse.questions ?? const [])
            ..addAll(result.questions ?? []);

      emit(state.copyWith(
        questionsListResponse: result,
        hasMore: state.hasMore,
        page: questions.length,
      ));
    } catch (e) {
      emit(state.copyWith(error: errorMessageAdapter(e)));
    }
  }
}
