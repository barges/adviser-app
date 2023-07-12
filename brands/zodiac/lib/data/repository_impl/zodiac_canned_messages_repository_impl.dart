import 'package:injectable/injectable.dart';

import 'package:zodiac/data/network/api/canned_messages_api.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';
import 'package:zodiac/data/network/requests/canned_messages_add_request.dart';
import 'package:zodiac/data/network/requests/canned_messages_delete_request.dart';
import 'package:zodiac/data/network/requests/canned_messages_request.dart';
import 'package:zodiac/data/network/requests/canned_messages_update_request.dart';
import 'package:zodiac/data/network/responses/base_response.dart';
import 'package:zodiac/data/network/responses/canned_categories_response.dart';
import 'package:zodiac/data/network/responses/canned_messages_add_response.dart';
import 'package:zodiac/data/network/responses/canned_messages_response.dart';
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
  Future<CannedMessagesAddResponse> addCannedMessage(
      CannedMessagesAddRequest request) async {
    return await _api.addCannedMessages(request);
  }

  @override
  Future<BaseResponse> updateCannedMessage(
      CannedMessagesUpdateRequest request) async {
    return await _api.updateCannedMessages(request);
  }

  @override
  Future<BaseResponse> deleteCannedMessage(
      CannedMessagesDeleteRequest request) async {
    return await _api.deleteCannedMessages(request);
  }

  @override
  Future<CannedCategoriesResponse> getCannedCategories(
      AuthorizedRequest request) async {
    return await _api.getCannedCategories(request);
  }
}
