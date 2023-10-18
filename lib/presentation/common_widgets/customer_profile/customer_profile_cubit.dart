import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../infrastructure/routing/app_router.dart';
import '../../../data/models/customer_info/customer_info.dart';
import '../../../data/models/customer_info/note.dart';
import '../../../domain/repositories/fortunica_customer_repository.dart';
import '../../../global.dart';
import '../../../infrastructure/di/inject_config.dart';
import '../../../infrastructure/routing/app_router.gr.dart';
import '../../screens/add_note/add_note_screen.dart';
import '../../screens/chat/chat_cubit.dart';
import '../../screens/customer_profile/customer_profile_screen.dart';
import 'customer_profile_state.dart';

class CustomerProfileCubit extends Cubit<CustomerProfileState> {
  final String customerID;
  final ValueChanged<CustomerProfileScreenArguments?>? updateClientInformation;
  final FortunicaCustomerRepository _repository =
      fortunicaGetIt.get<FortunicaCustomerRepository>();
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
      emit(state.copyWith(needRefresh: false));
    } catch (e) {
      emit(state.copyWith(needRefresh: true));
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

  void updateNote(BuildContext context, Note note) {
    context.push(
        route: FortunicaAddNote(
      addNoteScreenArguments: AddNoteScreenArguments(
        customerId: customerID,
        oldNote: note.content,
        updatedAt: note.updatedAt,
        noteChanged: getNotes,
      ),
    ));
  }

  void createNewNote(BuildContext context) {
    context.push(
      route: FortunicaAddNote(
        addNoteScreenArguments: AddNoteScreenArguments(
          customerId: customerID,
          noteChanged: getNotes,
        ),
      ),
    );
  }
}
