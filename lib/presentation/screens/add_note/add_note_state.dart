import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_note_state.freezed.dart';

@freezed
class AddNoteState with _$AddNoteState {
  factory AddNoteState(
      {@Default('') String newNote,
      @Default([]) List<String> imagesPaths,
      @Default(false) bool hadTitle}) = _AddNoteState;
}
