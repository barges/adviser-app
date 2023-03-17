// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:fortunica/data/models/chats/chat_item.dart';

part 'story.freezed.dart';
part 'story.g.dart';

@freezed
class Story with _$Story {
  @JsonSerializable(includeIfNull: false)
  const factory Story({
    final List<ChatItem>? questions,
    final List<ChatItem>? answers,
  }) = _Story;

  factory Story.fromJson(Map<String, dynamic> json) => _$StoryFromJson(json);
}
