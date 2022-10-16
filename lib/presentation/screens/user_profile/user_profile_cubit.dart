import 'package:bloc/bloc.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/domain/repositories/customer_repository.dart';

import 'user_profile_state.dart';

class UserProfileCubit extends Cubit<UserProfileState> {
  final String customerID;
  final CustomerRepository _repository = Get.find<CustomerRepository>();

  UserProfileCubit(this.customerID) : super(UserProfileState()) {
    getCustomerInfo(customerID);
  }

  //TODO -- remove this later
  bool isTopSpender = true;

  void updateIsFavorite() {
    emit(state.copyWith(isFavorite: !state.isFavorite));
  }

  Future<void> getCustomerInfo(String customerID) async {
    emit(state.copyWith(
        response: await _repository.getCustomerInfo(customerID)));
  }
}
