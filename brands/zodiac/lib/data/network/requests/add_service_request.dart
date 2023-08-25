import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/models/enums/service_type.dart';
import 'package:zodiac/data/models/services/service_language_model.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';

part 'add_service_request.g.dart';

@JsonSerializable(
    fieldRename: FieldRename.snake, includeIfNull: false, explicitToJson: true)
class AddServiceRequest extends AuthorizedRequest {
  final double price;
  final int duration;
  @JsonKey(fromJson: ServiceType.fromInt, toJson: ServiceType.toInt)
  final ServiceType type;
  final String imageAlias;
  //TODO - Maybe is required
  @JsonKey(name: 'default_locale')
  final String? mainLocale;
  final List<ServiceLanguageModel> translations;

  AddServiceRequest({
    required this.price,
    required this.duration,
    required this.type,
    required this.imageAlias,
    this.mainLocale,
    required this.translations,
  }) : super();

  factory AddServiceRequest.fromJson(Map<String, dynamic> json) =>
      _$AddServiceRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AddServiceRequestToJson(this);
}
