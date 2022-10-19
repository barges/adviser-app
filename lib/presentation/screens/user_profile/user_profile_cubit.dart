import 'package:bloc/bloc.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/domain/repositories/customer_repository.dart';
import 'package:shared_advisor_interface/presentation/resources/app_routes.dart';
import 'package:shared_advisor_interface/presentation/screens/user_profile/user_profile_state.dart';

class UserProfileCubit extends Cubit<UserProfileState> {
  late final String customerID;
  final CustomerRepository _repository = Get.find<CustomerRepository>();

  UserProfileCubit() : super(UserProfileState()) {
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
    final String? note =
        (await _repository.getNoteForCustomer(customerID)).content;
    emit(state.copyWith(currentNote: note));
  }

  void updateNoteToCustomer(String newContent) {
    emit(state.copyWith(currentNote: newContent));
  }

  void navigateToAddNoteScreenForOldNote() {
    Get.toNamed(AppRoutes.addNote, arguments: {
      'customerID': customerID,
      'oldNote': state.currentNote,
    });
  }

  void navigateToAddNoteScreenForNewNote() {
    Get.toNamed(AppRoutes.addNote, arguments: {
      'customerID': customerID,
    });
  }
}
