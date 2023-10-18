import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../main_cubit.dart';
import 'customer_profile_screen.dart';
import 'customer_profile_screen_state.dart';

class CustomerProfileScreenCubit extends Cubit<CustomerProfileScreenState> {
  final MainCubit _mainCubit;

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
