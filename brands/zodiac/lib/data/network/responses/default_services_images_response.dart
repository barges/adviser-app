import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/network/responses/base_response.dart';

part 'default_services_images_response.g.dart';

@JsonSerializable(includeIfNull: false)
class DefaultServicesImagesResponse extends BaseResponse {
  @JsonKey(name: 'default_images')
  final Map<String, String>? defaultImages;

  const DefaultServicesImagesResponse({
    super.status,
    super.errorCode,
    super.errorMsg,
    super.message,
    this.defaultImages,
  });

  factory DefaultServicesImagesResponse.fromJson(Map<String, dynamic> json) =>
      _$DefaultServicesImagesResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$DefaultServicesImagesResponseToJson(this);
}
