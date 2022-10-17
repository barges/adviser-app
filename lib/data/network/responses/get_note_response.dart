import 'package:json_annotation/json_annotation.dart';

part 'get_note_response.g.dart';

@JsonSerializable(includeIfNull: false)
class GetNoteResponse {
  final String? content;

  const GetNoteResponse(this.content);

  factory GetNoteResponse.fromJson(Map<String, dynamic> json) =>
      _$GetNoteResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetNoteResponseToJson(this);
}
