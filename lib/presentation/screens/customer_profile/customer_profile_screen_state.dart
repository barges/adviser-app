import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/customer_profile/customer_profile_widget.dart';

part 'customer_profile_screen_state.freezed.dart';

@freezed
class CustomerProfileScreenState with _$CustomerProfileScreenState {
  const factory CustomerProfileScreenState({
    AppBarUpdateArguments? appBarUpdateArguments,
  }) = _CustomerProfileScreenState;
}
