// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'video_info.g.dart';
part 'video_info.freezed.dart';

@freezed
class VideoInfo with _$VideoInfo {
  const VideoInfo._();

  @JsonSerializable(includeIfNull: false, createToJson: true)
  const factory VideoInfo({
    int? id,
    String? email,
    String? name,
  }) = _VideoInfo;

  factory VideoInfo.fromJson(Map<String, dynamic> json) =>
      _$VideoInfoFromJson(json);
}
