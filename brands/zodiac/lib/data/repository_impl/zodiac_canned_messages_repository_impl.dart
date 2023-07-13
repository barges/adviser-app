import 'package:injectable/injectable.dart';

import 'package:zodiac/data/network/api/canned_messages_api.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';
import 'package:zodiac/data/network/requests/canned_messages/canned_messages_request.dart';
import 'package:zodiac/data/network/responses/base_response.dart';
import 'package:zodiac/data/network/responses/canned_messages/canned_messages_response.dart';
import 'package:zodiac/domain/repositories/zodiac_canned_messages_repository.dart';

@Injectable(as: ZodiacCannedMessagesRepository)
class ZodiacCannedMessagesRepositoryImpl
    implements ZodiacCannedMessagesRepository {
  final CannedMessagesApi _api;

  ZodiacCannedMessagesRepositoryImpl(this._api);

  @override
  Future<CannedMessagesResponse> getCannedMessages(
      CannedMessagesRequest request) async {
    return await _api.getCannedMessages(request);
  }

  @override
  Future<CannedMessagesResponse> addCannedMessage(
      CannedMessagesRequest request) async {
    return await _api.addCannedMessages(request);
  }

  @override
  Future<BaseResponse> updateCannedMessage(
      CannedMessagesRequest request) async {
    return await _api.updateCannedMessages(request);
  }

  @override
  Future<BaseResponse> deleteCannedMessage(
      CannedMessagesRequest request) async {
    return await _api.deleteCannedMessages(request);
  }

  @override
  Future<CannedMessagesResponse> getCannedCategories(
      AuthorizedRequest request) async {
    return await _api.getCannedCategories(request);
  }
}
