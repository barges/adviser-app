import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_advisor_interface/presentation/resources/app_arguments.dart';

part 'customer_profile_screen_state.freezed.dart';

@freezed
class CustomerProfileScreenState with _$CustomerProfileScreenState {
  const factory CustomerProfileScreenState({
    CustomerProfileScreenArguments? appBarUpdateArguments,
  }) = _CustomerProfileScreenState;
}
