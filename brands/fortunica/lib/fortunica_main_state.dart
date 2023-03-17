import 'package:shared_advisor_interface/data/models/app_error/app_error.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'fortunica_main_state.freezed.dart';

@freezed
class FortunicaMainState with _$FortunicaMainState {
  const factory FortunicaMainState({
    @Default(EmptyError()) AppError appError,
  }) = _FortunicaMainState;
}
