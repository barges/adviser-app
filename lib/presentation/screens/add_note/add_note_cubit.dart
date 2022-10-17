import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/data/network/responses/update_note_response.dart';
import 'package:shared_advisor_interface/domain/repositories/customer_repository.dart';
import 'package:shared_advisor_interface/presentation/screens/user_profile/user_profile_cubit.dart';

import 'add_note_state.dart';

class AddNoteCubit extends Cubit<AddNoteState> {
  final String customerID;
  final String? oldNote;
  final CustomerRepository _repository = Get.find<CustomerRepository>();
  final UserProfileCubit _userProfileCubit = Get.find<UserProfileCubit>();
  late final TextEditingController controller;

  AddNoteCubit(this.customerID, this.oldNote) : super(AddNoteState()) {
    controller = TextEditingController(text: oldNote ?? '');
  }

  Future<void> addNoteToCustomer() async {
    UpdateNoteResponse response = await _repository.updateNoteToCustomer(
        clientID: customerID, content: controller.text);
    if (response.content == controller.text) {
      emit(state.copyWith(newNote: controller.text));
      _userProfileCubit.updateNoteToCustomer(controller.text);
    }
  }
}
