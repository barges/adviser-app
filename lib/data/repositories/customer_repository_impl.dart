import 'package:shared_advisor_interface/data/network/api/customer_api.dart';
import 'package:shared_advisor_interface/data/network/requests/update_note_request.dart';
import 'package:shared_advisor_interface/data/models/customer_info.dart';
import 'package:shared_advisor_interface/data/network/responses/get_note_response.dart';
import 'package:shared_advisor_interface/data/network/responses/update_note_response.dart';
import 'package:shared_advisor_interface/domain/repositories/customer_repository.dart';

class CustomerRepositoryImpl implements CustomerRepository {
  final CustomerApi _api;

  const CustomerRepositoryImpl(this._api);

  @override
  Future<CustomerInfo> getCustomerInfo(String customerID) async {
    return await _api.getCustomerInfo(customerID);
  }

  @override
  Future<GetNoteResponse> getNoteForCustomer(String customerID) async {
    return await _api.getNoteForCustomer(customerID);
  }

  @override
  Future<UpdateNoteResponse> updateNoteToCustomer(
      {required String clientID,
      required String content,
      required updatedAt}) async {
    return await _api.updateNoteToCustomer(
      UpdateNoteRequest(
          clientID: clientID, content: content, updatedAt: updatedAt),
    );
  }
}
