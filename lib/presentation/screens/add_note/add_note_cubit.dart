import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_advisor_interface/data/network/responses/update_note_response.dart';
import 'package:shared_advisor_interface/domain/repositories/customer_repository.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/presentation/screens/user_profile/user_profile_cubit.dart';

import 'add_note_state.dart';

class AddNoteCubit extends Cubit<AddNoteState> {
  final String customerID;
  final String? oldNote;
  final String? noteDate;
  final CustomerRepository _repository = Get.find<CustomerRepository>();
  final UserProfileCubit _userProfileCubit = Get.find<UserProfileCubit>();
  late final TextEditingController controller;

  AddNoteCubit(this.customerID, this.oldNote, this.noteDate)
      : super(AddNoteState()) {
    controller = TextEditingController(text: oldNote ?? '');
  }

  Future<void> addNoteToCustomer() async {
    UpdateNoteResponse response = await _repository.updateNoteToCustomer(
        clientID: customerID, content: controller.text);
    if (response.content == controller.text) {
      emit(state.copyWith(newNote: controller.text.removeSpacesAndNewLines));
      _userProfileCubit.updateNoteToCustomer(state.newNote);
    }
  }

  Future<void> addImagesToNote() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? images = await picker.pickMultiImage();
    if (images != null) {
      List<String> imagesPaths = [];
      for (var element in images) {
        imagesPaths.add(element.path);
      }
      emit(state.copyWith(imagesPaths: imagesPaths));
    }
  }
}
