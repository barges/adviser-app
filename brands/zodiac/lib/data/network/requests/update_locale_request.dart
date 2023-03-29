import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';

part 'update_locale_request.g.dart';

@JsonSerializable(includeIfNull: false)
class UpdateLocaleRequest extends AuthorizedRequest {
  String locale;

  UpdateLocaleRequest({required this.locale}) : super();

  factory UpdateLocaleRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateLocaleRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$UpdateLocaleRequestToJson(this);
}
