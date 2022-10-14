import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'update_note_response.g.dart';

@JsonSerializable(includeIfNull: false)
class UpdateNoteResponse extends Equatable {
  @JsonKey(name: '_id')
  final String? id;
  final String? content;
  final String? expertID;
  final String? clientID;
  final String? searchKey;
  final String? createdAt;
  final String? updatedAt;
  final int? v;

  const UpdateNoteResponse({
    this.id,
    this.content,
    this.expertID,
    this.clientID,
    this.searchKey,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory UpdateNoteResponse.fromJson(Map<String, dynamic> json) =>
      _$UpdateNoteResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateNoteResponseToJson(this);

  @override
  List<Object?> get props => [
        id,
        content,
        expertID,
        clientID,
        searchKey,
        createdAt,
        updatedAt,
        v,
      ];
}
