import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/models/user_info/locale_descriptions.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';

part 'profile_details_request.g.dart';

@JsonSerializable(
  includeIfNull: false,
  fieldRename: FieldRename.snake,
  explicitToJson: true,
)
class ProfileDetailsRequest extends AuthorizedRequest {
  int userId;

  ProfileDetailsRequest({
    required this.userId,
  }) : super();

  factory ProfileDetailsRequest.fromJson(Map<String, dynamic> json) =>
      _$ProfileDetailsRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ProfileDetailsRequestToJson(this);
}
