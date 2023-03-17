import 'package:shared_advisor_interface/data/models/app_error/app_error.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'zodiac_main_state.freezed.dart';

@freezed
class ZodiacMainState with _$ZodiacMainState {
  const factory ZodiacMainState({
    @Default(EmptyError()) AppError appError,
  }) = _ZodiacMainState;
}
