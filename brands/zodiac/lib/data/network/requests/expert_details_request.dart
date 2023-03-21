import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';

part 'expert_details_request.g.dart';

@JsonSerializable(includeIfNull: false)
class ExpertDetailsRequest extends AuthorizedRequest {
  @JsonKey(name: 'expert_id')
  int expertId;

  ExpertDetailsRequest({required this.expertId}) : super();

  factory ExpertDetailsRequest.fromJson(Map<String, dynamic> json) =>
      _$ExpertDetailsRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ExpertDetailsRequestToJson(this);
}
