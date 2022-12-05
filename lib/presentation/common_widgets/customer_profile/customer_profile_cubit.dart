import 'package:bloc/bloc.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/data/models/customer_info/note.dart';
import 'package:shared_advisor_interface/domain/repositories/customer_repository.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/customer_profile/customer_profile_state.dart';
import 'package:shared_advisor_interface/presentation/resources/app_arguments.dart';
import 'package:shared_advisor_interface/presentation/resources/app_routes.dart';

class CustomerProfileCubit extends Cubit<CustomerProfileState> {
  final String customerID;
  final CustomerRepository _repository = getIt.get<CustomerRepository>();

  CustomerProfileCubit(this.customerID) : super(CustomerProfileState()) {
    getCustomerInfo().then((_) => getNotes());
  }

  void updateIsFavorite() {
    emit(state.copyWith(isFavorite: !state.isFavorite));
  }

  Future<void> getCustomerInfo() async {
    emit(
      state.copyWith(
        customerInfo: await _repository.getCustomerInfo(customerID),
      ),
    );
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