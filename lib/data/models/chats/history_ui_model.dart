import 'package:freezed_annotation/freezed_annotation.dart';
import 'chat_item.dart';
import 'history.dart';

part 'history_ui_model.freezed.dart';

@freezed
class HistoryUiModel with _$HistoryUiModel {
  const factory HistoryUiModel.data(History history) = Data;

  const factory HistoryUiModel.separator(ChatItem? question) = Separator;
}
