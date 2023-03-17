import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortunica/fortunica_main_cubit.dart';
import 'package:fortunica/presentation/screens/customer_profile/customer_profile_screen.dart';

import 'customer_profile_screen_state.dart';

class CustomerProfileScreenCubit extends Cubit<CustomerProfileScreenState> {
  final FortunicaMainCubit _mainCubit;

  late final CustomerProfileScreenArguments _arguments;

  CustomerProfileScreenCubit(this._mainCubit, this._arguments)
      : super(const CustomerProfileScreenState()) {
    emit(state.copyWith(
      appBarUpdateArguments: _arguments,
    ));
  }

  void updateAppBarInformation(
      CustomerProfileScreenArguments? appBarUpdateArguments) {
    emit(state.copyWith(
      appBarUpdateArguments: appBarUpdateArguments,
    ));
  }

  void closeErrorWidget() {
    _mainCubit.clearErrorMessage();
  }
}
