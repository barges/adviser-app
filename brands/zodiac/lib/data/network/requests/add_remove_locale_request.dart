import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/models/user_info/locale_descriptions.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';

part 'add_remove_locale_request.g.dart';

@JsonSerializable(
  includeIfNull: false,
  fieldRename: FieldRename.snake,
  explicitToJson: true,
)
class AddRemoveLocaleRequest extends AuthorizedRequest {
  @JsonKey(name: 'lang_id')
  String? brandId;
  String? localeCode;
  LocaleDescriptions? data;

  AddRemoveLocaleRequest({
    this.brandId,
    this.localeCode,
    this.data,
  }) : super();

  factory AddRemoveLocaleRequest.fromJson(Map<String, dynamic> json) =>
      _$AddRemoveLocaleRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AddRemoveLocaleRequestToJson(this);
}
