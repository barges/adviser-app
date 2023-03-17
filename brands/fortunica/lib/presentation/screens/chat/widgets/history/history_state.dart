import 'package:fortunica/data/models/chats/history_ui_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'history_state.freezed.dart';

@freezed
class HistoryState with _$HistoryState {
  const factory HistoryState({
    @Default('') String errorMessage,
    @Default('') String successMessage,
    List<HistoryUiModel>? topHistoriesList,
    List<HistoryUiModel>? bottomHistoriesList,
  }) = _HistoryState;
}
