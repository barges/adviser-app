import 'package:fortunica/presentation/screens/customer_profile/customer_profile_screen.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'customer_profile_screen_state.freezed.dart';

@freezed
class CustomerProfileScreenState with _$CustomerProfileScreenState {
  const factory CustomerProfileScreenState({
    CustomerProfileScreenArguments? appBarUpdateArguments,
  }) = _CustomerProfileScreenState;
}
