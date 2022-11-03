import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'media_message.g.dart';

@JsonSerializable()
class MediaMessage extends Equatable {
  final String? audioPath;
  final String? imagePath;
  final Duration? duration;

  const MediaMessage({
    this.audioPath,
    this.imagePath,
    this.duration,
  });

  factory MediaMessage.fromJson(Map<String, dynamic> json) =>
      _$MediaMessageFromJson(json);

  Map<String, dynamic> toJson() => _$MediaMessageToJson(this);

  @override
  List<Object?> get props => [audioPath, imagePath, duration];
}
