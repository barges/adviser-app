import 'package:zodiac/data/network/requests/authorized_request.dart';
import 'package:zodiac/data/network/requests/canned_messages/canned_messages_request.dart';
import 'package:zodiac/data/network/responses/base_response.dart';
import 'package:zodiac/data/network/responses/canned_messages/canned_messages_response.dart';

abstract class ZodiacCannedMessagesRepository {
  Future<CannedMessagesResponse> getCannedMessages(
      CannedMessagesRequest request);

  Future<CannedMessagesResponse> addCannedMessage(
      CannedMessagesRequest request);

  Future<BaseResponse> updateCannedMessage(CannedMessagesRequest request);

  Future<BaseResponse> deleteCannedMessage(CannedMessagesRequest request);

  Future<CannedMessagesResponse> getCannedCategories(AuthorizedRequest request);
}
