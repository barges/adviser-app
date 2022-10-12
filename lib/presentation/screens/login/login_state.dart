import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_advisor_interface/configuration.dart';

part 'login_state.freezed.dart';

@freezed
class LoginState with _$LoginState {
  const factory LoginState({
    @Default('') String successMessage,
    @Default(false) bool showOpenEmailButton,
    @Default(Brand.fortunica) Brand selectedBrand,
    @Default([]) List<Brand> unauthorizedBrands,
    @Default('') String emailErrorText,
    @Default('') String passwordErrorText,
    @Default(true) bool hiddenPassword,
  }) = _LoginState;
}
