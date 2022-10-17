import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_note_state.freezed.dart';

@freezed
class AddNoteState with _$AddNoteState {
  factory AddNoteState({
    @Default('') String newNote,
  }) = _AddNoteState;
}
