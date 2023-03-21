import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';

part 'update_random_call_enabled_request.g.dart';

@JsonSerializable(includeIfNull: false)
class UpdateRandomCallEnabledRequest extends AuthorizedRequest {
  @JsonKey(name: 'random_call_enabled')
  final bool randomCallEnabled;

  UpdateRandomCallEnabledRequest({required this.randomCallEnabled});

  factory UpdateRandomCallEnabledRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateRandomCallEnabledRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$UpdateRandomCallEnabledRequestToJson(this);
}
