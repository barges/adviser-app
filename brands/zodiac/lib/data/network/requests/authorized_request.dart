import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/cache/zodiac_caching_manager.dart';
import 'package:zodiac/data/network/requests/base_request.dart';
import 'package:zodiac/infrastructure/di/inject_config.dart';

part 'authorized_request.g.dart';

@JsonSerializable(includeIfNull: false)
class AuthorizedRequest extends BaseRequest {
  String? auth = zodiacGetIt.get<ZodiacCachingManager>().getUserToken();

  AuthorizedRequest();

  factory AuthorizedRequest.fromJson(Map<String, dynamic> json) =>
      _$AuthorizedRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AuthorizedRequestToJson(this);
}
