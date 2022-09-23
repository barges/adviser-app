import 'package:json_annotation/json_annotation.dart';

part 'user_status.g.dart';

@JsonSerializable(includeIfNull: false)
class UserStatus {
  final String? profile;
  final String? messaging;
  final String? calling;
  final bool? cancelDuringOffline;

  const UserStatus({
    this.profile,
    this.messaging,
    this.calling,
    this.cancelDuringOffline,
  });

  factory UserStatus.fromJson(Map<String, dynamic> json) =>
      _$UserStatusFromJson(json);

  Map<String, dynamic> toJson() => _$UserStatusToJson(this);
}
