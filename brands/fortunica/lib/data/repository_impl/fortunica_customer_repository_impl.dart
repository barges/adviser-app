

import 'package:fortunica/data/models/customer_info/customer_info.dart';
import 'package:fortunica/data/models/customer_info/note.dart';
import 'package:fortunica/data/network/api/customer_api.dart';
import 'package:fortunica/data/network/requests/update_note_request.dart';
import 'package:fortunica/data/network/responses/update_note_response.dart';
import 'package:fortunica/domain/repositories/fortunica_customer_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: FortunicaCustomerRepository)
class FortunicaCustomerRepositoryImpl implements FortunicaCustomerRepository {
  final CustomerApi _api;

  const FortunicaCustomerRepositoryImpl(this._api);

  @override
  Future<CustomerInfo> getCustomerInfo(String customerID) async {
    return await _api.getCustomerInfo(customerID);
  }

  @override
  Future<Note> getNoteForCustomer(String customerID) async {
    return await _api.getNoteForCustomer(customerID);
  }

  @override
  Future<UpdateNoteResponse> updateNoteToCustomer(
      {required String clientID, required String content}) async {
    return await _api.updateNoteToCustomer(
      UpdateNoteRequest(clientID: clientID, content: content),
    );
  }
}