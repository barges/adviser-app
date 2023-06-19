import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'reaction_feature_state.freezed.dart';

@freezed
class ReactionFeatureState with _$ReactionFeatureState {
  const factory ReactionFeatureState({
    @Default([]) List<Emoji> recentEmojis,
  }) = _ReactionFeatureState;
}
