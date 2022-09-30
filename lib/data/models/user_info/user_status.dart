import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_advisor_interface/data/models/enums/fortunica_user_status.dart';

part 'user_status.freezed.dart';

part 'user_status.g.dart';

@freezed
class UserStatus with _$UserStatus {
  @JsonSerializable(includeIfNull: false)
  const factory UserStatus({
    @JsonKey(name: 'profile')
    @Default(FortunicaUserStatusEnum.live)
        FortunicaUserStatusEnum? status,
    String? messaging,
    String? calling,
    bool? cancelDuringOffline,
  }) = _UserStatus;

  factory UserStatus.fromJson(Map<String, dynamic> json) =>
      _$UserStatusFromJson(json);
}
