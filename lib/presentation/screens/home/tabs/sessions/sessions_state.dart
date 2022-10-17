import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_advisor_interface/data/models/question.dart';

part 'sessions_state.freezed.dart';

@freezed
class SessionsState with _$SessionsState {
  const factory SessionsState([
    @Default([]) List<Question> questions,
    @Default(0) int currentOptionIndex,
    @Default(0) int selectedFilterIndex,
  ]) = _SessionsState;
}
