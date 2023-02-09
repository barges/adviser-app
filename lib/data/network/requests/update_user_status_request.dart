import 'package:json_annotation/json_annotation.dart';
import 'package:shared_advisor_interface/data/models/enums/fortunica_user_status.dart';

part 'update_user_status_request.g.dart';

@JsonSerializable(includeIfNull: false)
class UpdateUserStatusRequest {
  final FortunicaUserStatus? status;
  final String? comment;

  UpdateUserStatusRequest({this.status, this.comment});

  factory UpdateUserStatusRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateUserStatusRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateUserStatusRequestToJson(this);
}
