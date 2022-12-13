import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_advisor_interface/data/models/chats/chat_item.dart';

part 'search_list_state.freezed.dart';

@freezed
class SearchListState with _$SearchListState {
  const factory SearchListState([
    @Default([]) List<ChatItem> conversationsList,
  ]) = _SearchListState;
}