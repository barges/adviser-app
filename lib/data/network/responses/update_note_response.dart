// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_note_response.g.dart';
part 'update_note_response.freezed.dart';

@freezed
class UpdateNoteResponse with _$UpdateNoteResponse {
  @JsonSerializable(includeIfNull: false)
  const factory UpdateNoteResponse({
    @JsonKey(name: '_id')
     String? id,
     String? content,
     String? expertID,
     String? clientID,
     String? searchKey,
     String? createdAt,
     String? updatedAt,
     int? v,
  }) = _UpdateNoteResponse;

  factory UpdateNoteResponse.fromJson(Map<String, dynamic> json) =>
      _$UpdateNoteResponseFromJson(json);
}
