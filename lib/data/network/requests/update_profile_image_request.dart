import 'package:json_annotation/json_annotation.dart';

part 'update_profile_image_request.g.dart';

@JsonSerializable(includeIfNull: false)
class UpdateProfileImageRequest {
  final String? mime;
  final String? image;

  UpdateProfileImageRequest({this.mime, this.image});

  factory UpdateProfileImageRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateProfileImageRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateProfileImageRequestToJson(this);
}
