import 'package:json_annotation/json_annotation.dart';
import 'package:fortunica/data/models/user_info/localized_properties/localized_properties.dart';

part 'update_profile_request.g.dart';

@JsonSerializable(includeIfNull: false)
class UpdateProfileRequest {
  final String? profileName;
  final LocalizedProperties? localizedProperties;

  UpdateProfileRequest({
    this.profileName,
    this.localizedProperties,
  });

  factory UpdateProfileRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateProfileRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateProfileRequestToJson(this);
}
