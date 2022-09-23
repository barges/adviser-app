import 'package:json_annotation/json_annotation.dart';
import 'package:shared_advisor_interface/data/models/localized_properties/localized_properties.dart';

part 'update_profile_request.g.dart';

@JsonSerializable(includeIfNull: false)
class UpdateProfileRequest {
  final String? profileName;
  final String? mime;
  final String? image;
  final LocalizedProperties? localizedProperties;

  UpdateProfileRequest({
    this.profileName,
    this.localizedProperties,
    this.mime,
    this.image,
  });

  factory UpdateProfileRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateProfileRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateProfileRequestToJson(this);
}
