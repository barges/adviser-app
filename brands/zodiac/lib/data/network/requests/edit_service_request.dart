import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/models/services/service_language_model.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';

part 'edit_service_request.g.dart';

@JsonSerializable(
    fieldRename: FieldRename.snake, includeIfNull: false, explicitToJson: true)
class EditServiceRequest extends AuthorizedRequest {
  final int duration;
  final String imageAlias;
  final List<ServiceLanguageModel> translations;
  final int serviceId;

  EditServiceRequest({
    required this.duration,
    required this.imageAlias,
    required this.translations,
    required this.serviceId,
  }) : super();

  factory EditServiceRequest.fromJson(Map<String, dynamic> json) =>
      _$EditServiceRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$EditServiceRequestToJson(this);
}
