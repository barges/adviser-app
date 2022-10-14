import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'update_note_request.g.dart';

@JsonSerializable(includeIfNull: false)
class UpdateNoteRequest extends Equatable {
  final String? clientID;
  final String? content;

  const UpdateNoteRequest({this.clientID, this.content});

  factory UpdateNoteRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateNoteRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateNoteRequestToJson(this);

  @override
  List<Object?> get props => [content, clientID];
}
