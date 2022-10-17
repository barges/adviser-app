import 'package:bloc/bloc.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/data/network/responses/update_note_response.dart';
import 'package:shared_advisor_interface/domain/repositories/customer_repository.dart';

import 'user_profile_state.dart';

class UserProfileCubit extends Cubit<UserProfileState> {
  final String customerID;
  final CustomerRepository _repository = Get.find<CustomerRepository>();

  UserProfileCubit(this.customerID) : super(UserProfileState()) {
    getCustomerInfo().then((_) => getCurrentNote());
  }

  //TODO -- remove this later
  bool isTopSpender = true;

  void updateIsFavorite() {
    emit(state.copyWith(isFavorite: !state.isFavorite));
  }

  Future<void> getCustomerInfo() async {
    emit(state.copyWith(
        response: await _repository.getCustomerInfo(customerID)));
  }

  Future<void> getCurrentNote() async {
    final String? note =
        (await _repository.getNoteForCustomer(customerID)).content;
    emit(state.copyWith(currentNote: note));
  }

  Future<void> updateNoteToCustomer(String newContent) async {
    UpdateNoteResponse response = await _repository.updateNoteToCustomer(
        clientID: customerID, content: newContent);
    if (response.content == newContent) {
      emit(state.copyWith(currentNote: newContent));
    }
  }
}
