import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:shared_advisor_interface/data/models/customer_info/customer_info.dart';
import 'package:shared_advisor_interface/data/network/requests/update_note_request.dart';
import 'package:shared_advisor_interface/data/models/customer_info/note.dart';
import 'package:shared_advisor_interface/data/network/responses/update_note_response.dart';

part 'customer_api.g.dart';

@RestApi()
abstract class CustomerApi {
  factory CustomerApi(Dio dio) = _CustomerApi;

  @GET('/v2/clients/{customerID}')
  Future<CustomerInfo> getCustomerInfo(@Path() String customerID);

  @GET('/notes')
  Future<Note> getNoteForCustomer(
      @Query('clientID') String customerID);

  @POST('/notes')
  Future<UpdateNoteResponse> updateNoteToCustomer(
      @Body() UpdateNoteRequest body);
}
