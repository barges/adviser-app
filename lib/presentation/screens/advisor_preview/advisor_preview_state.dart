import 'package:freezed_annotation/freezed_annotation.dart';

part 'advisor_preview_state.freezed.dart';

@freezed
class AdvisorPreviewState with _$AdvisorPreviewState {
  factory AdvisorPreviewState({
    @Default(0) int currentIndex,
    @Default(0) int oldIndex,
    @Default(true) bool updateInfo,
  }) = _AdvisorPreviewState;
}
