import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/presentation/resources/app_arguments.dart';

import 'customer_profile_screen_state.dart';

class CustomerProfileScreenCubit extends Cubit<CustomerProfileScreenState> {

  late final CustomerProfileScreenArguments arguments;

  CustomerProfileScreenCubit() : super(const CustomerProfileScreenState()) {
    arguments = Get.arguments;
    emit(state.copyWith(
      appBarUpdateArguments: arguments,
    ));
  }

  void updateAppBarInformation(CustomerProfileScreenArguments? appBarUpdateArguments) {
    emit(state.copyWith(
      appBarUpdateArguments: appBarUpdateArguments,
    ));
  }
}
