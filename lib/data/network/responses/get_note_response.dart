import 'package:json_annotation/json_annotation.dart';

part 'get_note_response.g.dart';

@JsonSerializable(includeIfNull: false)
class GetNoteResponse {
  final String? content;
  final String? createdAt;
  final String? updatedAt;

  const GetNoteResponse(this.content, this.createdAt, this.updatedAt);

  factory GetNoteResponse.fromJson(Map<String, dynamic> json) =>
      _$GetNoteResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetNoteResponseToJson(this);
}
