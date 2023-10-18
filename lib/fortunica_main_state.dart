import 'package:freezed_annotation/freezed_annotation.dart';
import 'data/models/app_error/app_error.dart';

part 'fortunica_main_state.freezed.dart';

@freezed
class FortunicaMainState with _$FortunicaMainState {
  const factory FortunicaMainState({
    @Default(EmptyError()) AppError appError,
  }) = _FortunicaMainState;
}
