import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';
import 'package:zodiac/data/network/requests/canned_messages_add_request.dart';
import 'package:zodiac/data/network/requests/canned_messages_delete_request.dart';
import 'package:zodiac/data/network/requests/canned_messages_request.dart';
import 'package:zodiac/data/network/requests/canned_messages_update_request.dart';
import 'package:zodiac/data/network/responses/base_response.dart';
import 'package:zodiac/data/network/responses/canned_categories_response.dart';
import 'package:zodiac/data/network/responses/canned_messages_add_response.dart';
import 'package:zodiac/data/network/responses/canned_messages_response.dart';

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
  Future<CannedMessagesAddResponse> addCannedMessages(
    @Body() CannedMessagesAddRequest request,
  );

  @POST('/canned-message/update')
  Future<BaseResponse> updateCannedMessages(
    @Body() CannedMessagesUpdateRequest request,
  );

  @POST('/canned-message/delete')
  Future<BaseResponse> deleteCannedMessages(
    @Body() CannedMessagesDeleteRequest request,
  );

  @POST('/canned-categories')
  Future<CannedCategoriesResponse> getCannedCategories(
    @Body() AuthorizedRequest request,
  );
}
