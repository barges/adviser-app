import 'package:json_annotation/json_annotation.dart';

part 'update_note_request.g.dart';

@JsonSerializable(includeIfNull: false)
class UpdateNoteRequest {
  final String? clientID;
  final String? content;
  final String? updatedAt;

  const UpdateNoteRequest(
      {required this.clientID, required this.content, required this.updatedAt});

  factory UpdateNoteRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateNoteRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateNoteRequestToJson(this);
}
