import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zodiac/data/models/canned_messages/canned_categorie.dart';
import 'package:zodiac/data/models/canned_messages/canned_message.dart';

part 'canned_messages_state.freezed.dart';

@freezed
class CannedMessagesState with _$CannedMessagesState {
  const factory CannedMessagesState({
    @Default([]) List<CannedCategorie> categories,
    @Default([]) List<CannedMessage> messages,
    @Default(false) bool isSaveTemplateButtonEnabled,
  }) = _CannedMessagesState;
}
