import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_advisor_interface/configuration.dart';

part 'login_state.freezed.dart';

@freezed
class LoginState with _$LoginState {
  const factory LoginState({
    @Default(false) bool isLoading,
    @Default('') String errorMessage,
    @Default('') String successMessage,
    @Default(false) bool showOpenEmailButton,
    @Default(Brand.fortunica) Brand selectedBrand,
    @Default([]) List<Brand> unauthorizedBrands,
    @Default('') String email,
    @Default('') String password,
    @Default(true) bool hiddenPassword,
  }) = _LoginState;
}
