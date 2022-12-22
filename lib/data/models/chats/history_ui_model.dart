import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_advisor_interface/data/models/chats/chat_item.dart';
import 'package:shared_advisor_interface/data/models/chats/history.dart';

part 'history_ui_model.freezed.dart';

@freezed
class HistoryUiModel with _$HistoryUiModel {
  const factory HistoryUiModel.data(History history) = Data;

  const factory HistoryUiModel.separator(ChatItem? question) = Separator;
}