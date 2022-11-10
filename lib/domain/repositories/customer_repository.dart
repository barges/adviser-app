import 'package:shared_advisor_interface/data/network/responses/customer_info_response/customer_info_response.dart';
import 'package:shared_advisor_interface/data/network/responses/get_note_response.dart';
import 'package:shared_advisor_interface/data/network/responses/update_note_response.dart';

abstract class CustomerRepository {
  Future<CustomerInfoResponse> getCustomerInfo(String customerID);

  Future<GetNoteResponse> getNoteForCustomer(String customerID);

  Future<UpdateNoteResponse> updateNoteToCustomer(
      {required String clientID,
      required String content,
      required String createdAt,
      required String updatedAt});
}
