import 'package:freezed_annotation/freezed_annotation.dart';

part 'zodiac_home_wrapper_state.freezed.dart';

@freezed
class ZodiacHomeWrapperState with _$ZodiacHomeWrapperState {
  const factory ZodiacHomeWrapperState({
    @Default(true) bool isProcessingData,
    @Default(true) bool isAuth,
  }) = _ZodiacHomeWrapperState;
}