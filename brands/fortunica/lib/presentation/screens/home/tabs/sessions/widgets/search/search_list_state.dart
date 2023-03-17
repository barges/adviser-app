import 'package:fortunica/data/models/chats/chat_item.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_list_state.freezed.dart';

@freezed
class SearchListState with _$SearchListState {
  const factory SearchListState([
    @Default([]) List<ChatItem> conversationsList,
  ]) = _SearchListState;
}