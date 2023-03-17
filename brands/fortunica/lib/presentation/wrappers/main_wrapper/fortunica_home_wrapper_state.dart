import 'package:freezed_annotation/freezed_annotation.dart';

part 'fortunica_home_wrapper_state.freezed.dart';

@freezed
class FortunicaHomeWrapperState with _$FortunicaHomeWrapperState {
  const factory FortunicaHomeWrapperState({
    @Default(true) bool isProcessingData,
    @Default(true) bool isAuth,
  }) = _FortunicaHomeWrapperState;
}