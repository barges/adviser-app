import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:shared_advisor_interface/data/network/requests/Update_note_request.dart';
import 'package:shared_advisor_interface/data/network/responses/Customer_info_response.dart';
import 'package:shared_advisor_interface/data/network/responses/update_note_response.dart';

part 'customer_api.g.dart';

@RestApi()
abstract class CustomerApi {
  factory CustomerApi(Dio dio) = _CustomerApi;

  @GET('/v2/clients/{customerID}')
  Future<CustomerInfoResponse> getCustomerInfo(@Path() String customerID);

  @POST('/notes')
  Future<UpdateNoteResponse> updateNoteToCustomer(
      @Body() UpdateNoteRequest body);
}
