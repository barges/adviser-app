import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/data/network/responses/update_note_response.dart';
import 'package:shared_advisor_interface/domain/repositories/customer_repository.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/presentation/resources/app_arguments.dart';

import 'add_note_state.dart';

class AddNoteCubit extends Cubit<AddNoteState> {
  late final AddNoteScreenArguments arguments;
  final String? oldTitle = null;
  final CustomerRepository _repository = getIt.get<CustomerRepository>();
  late final TextEditingController noteController;
  late final TextEditingController titleController;

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
          clientID: arguments.customerID, content: noteController.text);
      if (response.content == noteController.text) {
        emit(state.copyWith(
            newNote: noteController.text.removeSpacesAndNewLines));
        arguments.noteChanged();
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
