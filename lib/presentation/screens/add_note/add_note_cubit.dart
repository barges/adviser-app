import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_advisor_interface/data/network/responses/update_note_response.dart';
import 'package:shared_advisor_interface/domain/repositories/customer_repository.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/presentation/screens/user_profile/user_profile_cubit.dart';

import 'add_note_state.dart';

class AddNoteCubit extends Cubit<AddNoteState> {
  late final String customerID;
  late final String? oldNote;
  late final String? noteDate;
  late final String? oldTitle;
  late final String? newTitle;
  final CustomerRepository _repository = Get.find<CustomerRepository>();
  final UserProfileCubit _userProfileCubit = Get.find<UserProfileCubit>();
  late final TextEditingController noteController;
  late final TextEditingController titleController;

  AddNoteCubit() : super(AddNoteState()) {
    final Map<String, String?> arguments = Get.arguments;
    customerID = arguments['customerID'] as String;
    oldNote = arguments['oldNote'];
    noteDate = arguments['noteDate'];
    oldTitle = null;
    noteController = TextEditingController(text: oldNote ?? '');
    titleController = TextEditingController(text: oldTitle ?? '');
    if (oldTitle != null) {
      emit(state.copyWith(hadTitle: true));
    }
  }
  Future<void> addNoteToCustomer() async {
    UpdateNoteResponse response = await _repository.updateNoteToCustomer(
        clientID: customerID,
        content: noteController.text,
        updatedAt: DateFormat(dateFormat).format(DateTime.now()));
    if (response.content == noteController.text) {
      emit(
          state.copyWith(newNote: noteController.text.removeSpacesAndNewLines));
      _userProfileCubit.updateNoteToCustomer(state.newNote);
    }
  }

  Future<void> attachPicture(File? image) async {
    if (image != null) {
      emit(state.copyWith(imagesPaths: [...state.imagesPaths, image.path]));
    }
  }

  void attachMultiPictures(List<File>? images) {
    if (images != null) {
      List<String> imagesPath = List.empty(growable: true);
      for (File image in images) {
        imagesPath.add(image.path);
      }
      emit(state.copyWith(imagesPaths: [...state.imagesPaths, ...imagesPath]));
    }
  }

  void addTitle() {
    emit(state.copyWith(hadTitle: true));
  }
}
