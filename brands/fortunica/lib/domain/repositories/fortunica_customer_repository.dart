
import 'package:fortunica/data/models/customer_info/customer_info.dart';
import 'package:fortunica/data/models/customer_info/note.dart';
import 'package:fortunica/data/network/responses/update_note_response.dart';

abstract class FortunicaCustomerRepository {
  Future<CustomerInfo> getCustomerInfo(String customerID);

  Future<Note> getNoteForCustomer(String customerID);

  Future<UpdateNoteResponse> updateNoteToCustomer(
      {required String clientID, required String content});
}
