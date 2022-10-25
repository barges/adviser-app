import 'package:freezed_annotation/freezed_annotation.dart';

part 'freshchat_info.freezed.dart';

part 'freshchat_info.g.dart';

@freezed
class FreshchatInfo with _$FreshchatInfo {
  @JsonSerializable(includeIfNull: false)
  const factory FreshchatInfo({
    String? restoreId,
  }) = _FreshchatInfo;

  factory FreshchatInfo.fromJson(Map<String, dynamic> json) =>
      _$FreshchatInfoFromJson(json);
}