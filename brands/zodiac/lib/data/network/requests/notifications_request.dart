import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/network/requests/list_request.dart';

part 'notifications_request.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class NotificationsRequest extends ListRequest {
  final bool fromScreen;

  NotificationsRequest({
    required super.count,
    required super.offset,
    this.fromScreen = false,
  }) : super();

  factory NotificationsRequest.fromJson(Map<String, dynamic> json) =>
      _$NotificationsRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$NotificationsRequestToJson(this);
}
