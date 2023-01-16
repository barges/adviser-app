import 'package:json_annotation/json_annotation.dart';

part 'reorder_cover_pictures_request.g.dart';

@JsonSerializable(includeIfNull: false)
class ReorderCoverPicturesRequest {
  final String? indexes;

  ReorderCoverPicturesRequest({
    this.indexes,
  });

  factory ReorderCoverPicturesRequest.fromJson(Map<String, dynamic> json) =>
      _$ReorderCoverPicturesRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ReorderCoverPicturesRequestToJson(this);
}
