import 'package:json_annotation/json_annotation.dart';

part 'note.g.dart';

@JsonSerializable(includeIfNull: false)
class Note {
  final String? content;
  final String? updatedAt;

  const Note(this.content, this.updatedAt);

  factory Note.fromJson(Map<String, dynamic> json) =>
      _$NoteFromJson(json);

  Map<String, dynamic> toJson() => _$NoteToJson(this);
}
