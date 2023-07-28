import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/models/services/image_sample_model.dart';
import 'package:zodiac/data/network/responses/base_response.dart';

part 'default_services_images_response.g.dart';

@JsonSerializable(includeIfNull: false)
class DefaultServicesImagesResponse extends BaseResponse {
  final List<ImageSampleModel>? samples;

  const DefaultServicesImagesResponse({
    super.status,
    super.errorCode,
    super.errorMsg,
    super.message,
    this.samples,
  });

  factory DefaultServicesImagesResponse.fromJson(Map<String, dynamic> json) =>
      _$DefaultServicesImagesResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$DefaultServicesImagesResponseToJson(this);
}
