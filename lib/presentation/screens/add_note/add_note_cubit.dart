import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_advisor_interface/data/network/responses/update_note_response.dart';
import 'package:shared_advisor_interface/domain/repositories/customer_repository.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/presentation/screens/customer_profile/customer_profile_cubit.dart';

import 'add_note_state.dart';

class AddNoteCubit extends Cubit<AddNoteState> {
  late final AddNoteScreenArguments arguments;
  final String? oldTitle = null;
  final CustomerRepository _repository = getIt.get<CustomerRepository>();
  late final TextEditingController noteController;
  late final TextEditingController titleController;

  ///TODO: Change arguments and add callback to arguments for change note on customer profile screen

  AddNoteCubit() : super(AddNoteState()) {
    arguments = Get.arguments as AddNoteScreenArguments;
    noteController = TextEditingController(text: arguments.oldNote ?? '');
    titleController = TextEditingController(text: oldTitle ?? '');
    if (oldTitle != null) {
      emit(state.copyWith(hadTitle: true));
    }
    if (arguments.oldNote != null) {
      emit(state.copyWith(isNoteNew: false));
    }
  }
  Future<void> addNoteToCustomer() async {
    if (noteController.text != arguments.oldNote) {
      UpdateNoteResponse response = await _repository.updateNoteToCustomer(
          clientID: arguments.customerID,
          content: noteController.text,
          updatedAt: DateFormat(dateFormat).format(DateTime.now()));
      if (response.content == noteController.text) {
        emit(state.copyWith(
            newNote: noteController.text.removeSpacesAndNewLines));
        arguments.noteChanged();
        //_userProfileCubit.updateNoteToCustomer(GetNoteResponse(
        //    noteController.text,
        //    DateFormat(dateFormat).format(DateTime.now())));
      }
    }
    Get.back();
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
