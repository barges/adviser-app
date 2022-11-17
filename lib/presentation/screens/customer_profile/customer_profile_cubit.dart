import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/data/network/responses/get_note_response.dart';
import 'package:shared_advisor_interface/domain/repositories/customer_repository.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/presentation/resources/app_routes.dart';
import 'package:shared_advisor_interface/presentation/screens/customer_profile/customer_profile_state.dart';

class CustomerProfileCubit extends Cubit<CustomerProfileState> {
  late final String customerID;
  final CustomerRepository _repository = getIt.get<CustomerRepository>();

  CustomerProfileCubit() : super(CustomerProfileState()) {
    customerID = Get.arguments as String;
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
    final GetNoteResponse note =
        await _repository.getNoteForCustomer(customerID);

    emit(state.copyWith(currentNote: note));
  }

  void navigateToAddNoteScreenForOldNote() {
    Get.toNamed(AppRoutes.addNote,
        arguments: AddNoteScreenArguments(
            customerID: customerID,
            oldNote: state.currentNote?.content,
            updatedAt: state.currentNote?.updatedAt,
            noteChanged: getCurrentNote));
  }

  void navigateToAddNoteScreenForNewNote() {
    Get.toNamed(AppRoutes.addNote,
        arguments: AddNoteScreenArguments(
            customerID: customerID, noteChanged: getCurrentNote));
  }
}

class AddNoteScreenArguments {
  final String customerID;
  final String? oldNote;
  final String? updatedAt;
  VoidCallback noteChanged;

  AddNoteScreenArguments(
      {required this.customerID,
      this.oldNote,
      this.updatedAt,
      required this.noteChanged});
}
