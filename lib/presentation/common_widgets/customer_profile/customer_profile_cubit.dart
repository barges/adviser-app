import 'package:bloc/bloc.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/domain/repositories/customer_repository.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/customer_profile/customer_profile_state.dart';
import 'package:shared_advisor_interface/presentation/resources/app_arguments.dart';
import 'package:shared_advisor_interface/presentation/resources/app_routes.dart';

class CustomerProfileCubit extends Cubit<CustomerProfileState> {
  final String customerID;
  final CustomerRepository _repository = getIt.get<CustomerRepository>();

  CustomerProfileCubit(this.customerID) : super(CustomerProfileState()) {
    getCustomerInfo().then((_) => getCurrentNote());
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

  Future<void> getCurrentNote() async {
    emit(
      state.copyWith(
        currentNote: await _repository.getNoteForCustomer(customerID),
      ),
    );
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
