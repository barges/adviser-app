import 'package:json_annotation/json_annotation.dart';

part 'restore_freshchat_id_request.g.dart';

@JsonSerializable(includeIfNull: false)
class RestoreFreshchatIdRequest {
  final String restoreId;

  RestoreFreshchatIdRequest({required this.restoreId});

  factory RestoreFreshchatIdRequest.fromJson(Map<String, dynamic> json) =>
      _$RestoreFreshchatIdRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RestoreFreshchatIdRequestToJson(this);
}
