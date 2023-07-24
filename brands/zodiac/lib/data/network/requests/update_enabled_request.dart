import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';

part 'update_enabled_request.g.dart';

@JsonSerializable(includeIfNull: false, fieldRename: FieldRename.snake)
class UpdateEnabledRequest extends AuthorizedRequest {
  bool isEnabled;

  UpdateEnabledRequest({required this.isEnabled}) : super();

  factory UpdateEnabledRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateEnabledRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$UpdateEnabledRequestToJson(this);
}
