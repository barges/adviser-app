import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../models/customer_info/customer_info.dart';
import '../../models/customer_info/note.dart';
import '../requests/update_note_request.dart';
import '../responses/update_note_response.dart';

part 'customer_api.g.dart';

@RestApi()
@injectable
abstract class CustomerApi {
  @factoryMethod
  factory CustomerApi(Dio dio) = _CustomerApi;

  @GET('/v2/clients/{customerID}')
  Future<CustomerInfo> getCustomerInfo(@Path() String customerID);

  @GET('/notes')
  Future<Note> getNoteForCustomer(@Query('clientID') String customerID);

  @POST('/notes')
  Future<UpdateNoteResponse> updateNoteToCustomer(
      @Body() UpdateNoteRequest body);
}
