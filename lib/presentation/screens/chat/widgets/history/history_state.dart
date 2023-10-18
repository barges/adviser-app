import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../data/models/chats/history_ui_model.dart';
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
