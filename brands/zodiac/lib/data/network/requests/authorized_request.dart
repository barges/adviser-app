import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/network/requests/base_request.dart';

part 'authorized_request.g.dart';

@JsonSerializable(includeIfNull: false)
class AuthorizedRequest extends BaseRequest {
  String auth = '5f8a5b058cef92bca9109bb3df6dc9d8';

  AuthorizedRequest();

  factory AuthorizedRequest.fromJson(Map<String, dynamic> json) =>
      _$AuthorizedRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AuthorizedRequestToJson(this);
}
