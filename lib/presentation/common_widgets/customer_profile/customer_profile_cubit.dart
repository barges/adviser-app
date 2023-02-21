import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/data/models/customer_info/customer_info.dart';
import 'package:shared_advisor_interface/data/models/customer_info/note.dart';
import 'package:shared_advisor_interface/domain/repositories/customer_repository.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/customer_profile/customer_profile_state.dart';
import 'package:shared_advisor_interface/presentation/resources/app_arguments.dart';
import 'package:shared_advisor_interface/presentation/resources/app_routes.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/chat_cubit.dart';

class CustomerProfileCubit extends Cubit<CustomerProfileState> {
  final String customerID;
  final ValueChanged<CustomerProfileScreenArguments?>? updateClientInformation;
  final CustomerRepository _repository = getIt.get<CustomerRepository>();
  final ChatCubit? _chatCubit;

  late final StreamSubscription<bool>? _refreshChatInfoSubscription;

  CustomerProfileCubit(
    this.customerID,
    this.updateClientInformation,
    this._chatCubit,
  ) : super(CustomerProfileState()) {
    getData();

    _refreshChatInfoSubscription =
        _chatCubit?.refreshChatInfoTrigger.listen((value) {
      getData();
    });
  }

  @override
  Future<void> close() async {
    _refreshChatInfoSubscription?.cancel();
    super.close();
  }

  void updateIsFavorite() {
    emit(state.copyWith(isFavorite: !state.isFavorite));
  }

  Future<void> getData() async {
    try {
      await getCustomerInfo();
      await getNotes();
      _refreshChatInfoSubscription?.cancel();
    } catch (e) {
      logger.d(e);
    }
  }

  Future<void> getCustomerInfo() async {
    CustomerInfo customerInfo = await _repository.getCustomerInfo(customerID);
    emit(
      state.copyWith(
        customerInfo: customerInfo,
      ),
    );
    if (updateClientInformation != null) {
      final String? firstName = customerInfo.firstName;
      final String? lastName = customerInfo.lastName;
      updateClientInformation!(
        CustomerProfileScreenArguments(
          customerID: customerID,
          clientName: firstName != null && lastName != null
              ? '$firstName $lastName'
              : null,
          zodiacSign: customerInfo.zodiac,
        ),
      );
    }
  }

  Future<void> getNotes() async {
    final Note note = await _repository.getNoteForCustomer(customerID);
    emit(
      state.copyWith(
        notes: note.content?.isNotEmpty == true ? [note] : [],
      ),
    );
  }

  void updateNote(Note note) {
    Get.toNamed(
      AppRoutes.addNote,
      arguments: AddNoteScreenArguments(
        customerID: customerID,
        oldNote: note.content,
        updatedAt: note.updatedAt,
        noteChanged: getNotes,
      ),
    );
  }

  void createNewNote() {
    Get.toNamed(
      AppRoutes.addNote,
      arguments: AddNoteScreenArguments(
        customerID: customerID,
        noteChanged: getNotes,
      ),
    );
  }
}
