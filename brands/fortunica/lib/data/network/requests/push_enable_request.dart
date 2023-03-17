import 'package:json_annotation/json_annotation.dart';

part 'push_enable_request.g.dart';

@JsonSerializable(includeIfNull: false)
class PushEnableRequest {
  final bool? value;

  PushEnableRequest({this.value});

  factory PushEnableRequest.fromJson(Map<String, dynamic> json) =>
      _$PushEnableRequestFromJson(json);

  Map<String, dynamic> toJson() => _$PushEnableRequestToJson(this);
}
