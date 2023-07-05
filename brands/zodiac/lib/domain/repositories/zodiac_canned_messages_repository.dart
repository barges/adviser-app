import 'package:zodiac/data/network/requests/authorized_request.dart';
import 'package:zodiac/data/network/requests/canned_messages_add_request.dart';
import 'package:zodiac/data/network/requests/canned_messages_delete_request.dart';
import 'package:zodiac/data/network/requests/canned_messages_request.dart';
import 'package:zodiac/data/network/requests/canned_messages_update_request.dart';
import 'package:zodiac/data/network/responses/base_response.dart';
import 'package:zodiac/data/network/responses/canned_categories_response.dart';
import 'package:zodiac/data/network/responses/canned_messages_add_response.dart';
import 'package:zodiac/data/network/responses/canned_messages_response.dart';

abstract class ZodiacCannedMessagesRepository {
  Future<CannedMessagesResponse> getCannedMessages(
      CannedMessagesRequest request);

  Future<CannedMessagesAddResponse> addCannedMessages(
      CannedMessagesAddRequest request);

  Future<BaseResponse> updateCannedMessages(
      CannedMessagesUpdateRequest request);

  Future<BaseResponse> deleteCannedMessages(
      CannedMessagesDeleteRequest request);

  Future<CannedCategoriesResponse> getCannedCategories(
      AuthorizedRequest request);
}
