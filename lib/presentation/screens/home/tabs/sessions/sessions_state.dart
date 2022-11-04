import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_advisor_interface/data/models/chats/question.dart';
import 'package:shared_advisor_interface/data/models/enums/markets_type.dart';

part 'sessions_state.freezed.dart';

@freezed
class SessionsState with _$SessionsState {
  const factory SessionsState([
    @Default([]) List<Question> privateQuestionsWithHistory,
    @Default([]) List<Question> publicQuestions,
    @Default([]) List<MarketsType> userMarkets,
    @Default(0) int currentOptionIndex,
    @Default(0) int currentMarketIndexForPublic,
    @Default(0) int currentMarketIndexForPrivate,
  ]) = _SessionsState;
}
