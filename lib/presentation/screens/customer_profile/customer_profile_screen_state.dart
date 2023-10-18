import 'package:freezed_annotation/freezed_annotation.dart';
import 'customer_profile_screen.dart';

part 'customer_profile_screen_state.freezed.dart';

@freezed
class CustomerProfileScreenState with _$CustomerProfileScreenState {
  const factory CustomerProfileScreenState({
    CustomerProfileScreenArguments? appBarUpdateArguments,
  }) = _CustomerProfileScreenState;
}
