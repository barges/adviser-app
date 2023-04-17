import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zodiac/presentation/common_widgets/appbar/scrollable_appbar/scrollable_appbar.dart';

part 'scrollable_appbar_state.freezed.dart';

@freezed
class ScrollableAppBarState with _$ScrollableAppBarState {
  factory ScrollableAppBarState({
    @Default(true) bool isWideAppBar,
    @Default(maxHeight) double appBarHeight,
  }) = _ScrollableAppBarState;
}
