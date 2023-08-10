import 'dart:io';

import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortunica/data/network/responses/update_note_response.dart';
import 'package:fortunica/domain/repositories/fortunica_customer_repository.dart';
import 'package:fortunica/fortunica_main_cubit.dart';
import 'package:fortunica/infrastructure/di/inject_config.dart';

import 'add_note_state.dart';

class AddNoteCubit extends Cubit<AddNoteState> {

  final String customerID;
  final String? oldNote;
  final VoidCallback noteChanged;

  final String? oldTitle = null;
  final FortunicaCustomerRepository _repository =
      fortunicaGetIt.get<FortunicaCustomerRepository>();
  late final TextEditingController noteController;
  late final TextEditingController titleController;
  final FortunicaMainCubit mainCubit;

  AddNoteCubit({
    required this.mainCubit,
    required this.customerID,
    required this.noteChanged,
    this.oldNote,
  }) : super(AddNoteState()) {
    noteController = TextEditingController(text: oldNote ?? '');
    titleController = TextEditingController(text: oldTitle ?? '');
    if (oldTitle != null) {
      emit(state.copyWith(hadTitle: true));
    }
    if (oldNote != null) {
      emit(state.copyWith(isNoteNew: false));
    }
  }

  Future<void> addNoteToCustomer(BuildContext context) async {
    if (noteController.text != oldNote) {
      UpdateNoteResponse response = await _repository.updateNoteToCustomer(
          clientID: customerID, content: noteController.text);
      if (response.content == noteController.text) {
        emit(state.copyWith(
            newNote: noteController.text.removeSpacesAndNewLines));
        noteChanged();
      }
    }
    context.pop();
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

  void closeErrorWidget() {
    mainCubit.clearErrorMessage();
  }
}