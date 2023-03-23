import 'package:freezed_annotation/freezed_annotation.dart';

part 'scrollable_appbar_state.freezed.dart';

@freezed
class ScrollableAppBarState with _$ScrollableAppBarState {
  factory ScrollableAppBarState({
    @Default(true) bool isWideAppBar,
  }) = _ScrollableAppBarState;
}
