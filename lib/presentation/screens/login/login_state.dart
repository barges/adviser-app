import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_advisor_interface/configuration.dart';

part 'login_state.freezed.dart';

@freezed
class LoginState with _$LoginState {
  const factory LoginState({
    @Default(Brand.fortunica) Brand selectedBrand,
    @Default([]) List<Brand> unauthorizedBrands,
    @Default('') String emailErrorText,
    @Default(false) bool emailHasFocus,
    @Default('') String passwordErrorText,
    @Default(false) bool passwordHasFocus,
    @Default(true) bool hiddenPassword,
  }) = _LoginState;
}
