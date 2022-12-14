import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/customer_profile/customer_profile_widget.dart';

import 'customer_profile_screen_state.dart';

class CustomerProfileScreenCubit extends Cubit<CustomerProfileScreenState> {
  CustomerProfileScreenCubit() : super(const CustomerProfileScreenState());

  void updateAppBarInformation(AppBarUpdateArguments? appBarUpdateArguments) {
    emit(state.copyWith(
      appBarUpdateArguments: appBarUpdateArguments,
    ));
  }
}
