import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/presentation/resources/app_arguments.dart';

import 'customer_profile_screen_state.dart';

class CustomerProfileScreenCubit extends Cubit<CustomerProfileScreenState> {
  CustomerProfileScreenCubit() : super(const CustomerProfileScreenState());

  void updateAppBarInformation(AppBarUpdateArguments? appBarUpdateArguments) {
    emit(state.copyWith(
      appBarUpdateArguments: appBarUpdateArguments,
    ));
  }
}
