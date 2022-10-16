import 'package:shared_advisor_interface/data/network/api/customer_api.dart';
import 'package:shared_advisor_interface/data/network/requests/update_note_request.dart';
import 'package:shared_advisor_interface/data/network/responses/customer_info_response/customer_info_response.dart';
import 'package:shared_advisor_interface/data/network/responses/update_note_response.dart';
import 'package:shared_advisor_interface/domain/repositories/customer_repository.dart';

class CustomerRepositoryImpl implements CustomerRepository {
  final CustomerApi _api;

  const CustomerRepositoryImpl(this._api);

  @override
  Future<CustomerInfoResponse> getCustomerInfo(String customerID) async {
    return await _api.getCustomerInfo(customerID);
  }

  @override
  Future<UpdateNoteResponse> updateNoteToCustomer(
      {required String clientID, required String content}) async {
    return await _api.updateNoteToCustomer(
      UpdateNoteRequest(clientID: clientID, content: content),
    );
  }
}
