import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/models/user_info/locale_descriptions.dart';
import 'package:zodiac/data/network/responses/base_response.dart';

part 'locale_descriptions_response.g.dart';

@JsonSerializable(includeIfNull: false)
class LocaleDescriptionsResponse extends BaseResponse {
  final LocaleDescriptions? result;

  const LocaleDescriptionsResponse({
    super.status,
    super.errorCode,
    super.errorMsg,
    super.message,
    this.result,
  });

  factory LocaleDescriptionsResponse.fromJson(Map<String, dynamic> json) =>
      _$LocaleDescriptionsResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$LocaleDescriptionsResponseToJson(this);
}
