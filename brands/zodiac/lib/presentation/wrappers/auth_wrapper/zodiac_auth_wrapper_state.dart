import 'package:freezed_annotation/freezed_annotation.dart';

part 'zodiac_auth_wrapper_state.freezed.dart';

@freezed
class ZodiacAuthWrapperState with _$ZodiacAuthWrapperState {
  const factory ZodiacAuthWrapperState({
    @Default(true) bool isProcessingData,
    @Default(false) bool isAuth,
  }) = _ZodiacAuthWrapperState;
}