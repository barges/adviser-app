import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';

part 'change_advisor_specializations_request.g.dart';

@JsonSerializable(
  includeIfNull: false,
  fieldRename: FieldRename.snake,
  explicitToJson: true,
)
class ChangeAdvisorSpecializationsRequest extends AuthorizedRequest {
  int saveForm = 1;
  List<int>? categories;

  ChangeAdvisorSpecializationsRequest({
    this.categories,
  }) : super();

  factory ChangeAdvisorSpecializationsRequest.fromJson(
          Map<String, dynamic> json) =>
      _$ChangeAdvisorSpecializationsRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$ChangeAdvisorSpecializationsRequestToJson(this);
}
