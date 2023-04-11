import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/models/user_info/locale_model.dart';
import 'package:zodiac/data/network/responses/base_response.dart';

part 'locales_response.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true,)
class LocalesResponse extends BaseResponse {
  final List<LocaleModel>? result;

  const LocalesResponse({
    super.status,
    super.errorCode,
    super.errorMsg,
    super.message,
    this.result,
  });

  factory LocalesResponse.fromJson(Map<String, dynamic> json) =>
      _$LocalesResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$LocalesResponseToJson(this);
}
