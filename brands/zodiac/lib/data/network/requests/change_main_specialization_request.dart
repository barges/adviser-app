import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';

part 'change_main_specialization_request.g.dart';

@JsonSerializable(
  includeIfNull: false,
  fieldRename: FieldRename.snake,
  explicitToJson: true,
)
class ChangeMainSpecializationRequest extends AuthorizedRequest {
  int saveForm = 1;
  int? categoryId;

  ChangeMainSpecializationRequest({
    this.categoryId,
  }) : super();

  factory ChangeMainSpecializationRequest.fromJson(Map<String, dynamic> json) =>
      _$ChangeMainSpecializationRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ChangeMainSpecializationRequestToJson(this);
}
