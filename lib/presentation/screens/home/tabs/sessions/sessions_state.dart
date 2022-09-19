import 'package:shared_advisor_interface/data/model/error_model.dart';
import 'package:shared_advisor_interface/data/network/responses/questions_list_response.dart';
import 'package:shared_advisor_interface/data/network/responses/rituals_response.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sessions_state.freezed.dart';

@freezed
class SessionsState with _$SessionsState {
  const factory SessionsState([
    @Default(false) bool isLoading,
    @Default(QuestionsListResponse()) QuestionsListResponse questionsListResponse,
    @Default(RitualsResponse()) RitualsResponse ritualsResponse,
    @Default(0) int page,
    @Default(true) bool hasMore,
    @Default(true) bool isPublic,
    @Default(0) int selectedFilterIndex,
    @Default(ErrorModel(errorType: ErrorType.connectingError)) ErrorModel error,
  ]) = _SessionsState;
}

