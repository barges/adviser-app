import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_advisor_interface/data/models/chats/history_ui_model.dart';

part 'history_state.freezed.dart';

@freezed
class HistoryState with _$HistoryState {
  const factory HistoryState({
    @Default(false) bool isLoadingAudio,
    @Default(false) bool isPlayingAudio,
    @Default(true) bool isPlayingAudioFinished,
    @Default('') String audioUrl,
    @Default('') String errorMessage,
    @Default('') String successMessage,
    List<HistoryUiModel>? topHistoriesList,
    List<HistoryUiModel>? bottomHistoriesList,
  }) = _HistoryState;
}
