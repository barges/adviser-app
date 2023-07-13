import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';
import 'package:zodiac/data/network/requests/canned_messages/canned_messages_request.dart';
import 'package:zodiac/data/network/responses/base_response.dart';
import 'package:zodiac/data/network/responses/canned_messages/canned_messages_response.dart';

part 'canned_messages_api.g.dart';

@RestApi()
@injectable
abstract class CannedMessagesApi {
  @factoryMethod
  factory CannedMessagesApi(Dio dio) = _CannedMessagesApi;

  @POST('/canned-messages')
  Future<CannedMessagesResponse> getCannedMessages(
    @Body() CannedMessagesRequest request,
  );

  @POST('/canned-message/add')
  Future<CannedMessagesResponse> addCannedMessages(
    @Body() CannedMessagesRequest request,
  );

  @POST('/canned-message/update')
  Future<BaseResponse> updateCannedMessages(
    @Body() CannedMessagesRequest request,
  );

  @POST('/canned-message/delete')
  Future<BaseResponse> deleteCannedMessages(
    @Body() CannedMessagesRequest request,
  );

  @POST('/canned-categories')
  Future<CannedMessagesResponse> getCannedCategories(
    @Body() AuthorizedRequest request,
  );
}
