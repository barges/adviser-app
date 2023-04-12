import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';

part 'locale_descriptions_request.g.dart';

@JsonSerializable(includeIfNull: false)
class LocaleDescriptionsRequest extends AuthorizedRequest {
  String locale;

  LocaleDescriptionsRequest({required this.locale}) : super();

  factory LocaleDescriptionsRequest.fromJson(Map<String, dynamic> json) =>
      _$LocaleDescriptionsRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$LocaleDescriptionsRequestToJson(this);
}