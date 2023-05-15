import 'package:injectable/injectable.dart';
import 'package:zodiac/data/network/api/sessions_api.dart';
import 'package:zodiac/data/network/requests/hide_chat_request.dart';
import 'package:zodiac/data/network/requests/list_request.dart';
import 'package:zodiac/data/network/responses/base_response.dart';
import 'package:zodiac/data/network/responses/chat_entities_response.dart';
import 'package:zodiac/domain/repositories/zodiac_sessions_repository.dart';

@Injectable(as: ZodiacSessionsRepository)
class ZodiacChatsRepositoryImpl implements ZodiacSessionsRepository {
  final SessionsApi _sessionsApi;

  const ZodiacChatsRepositoryImpl(this._sessionsApi);

  @override
  Future<ChatEntitiesResponse> getChatsList(ListRequest request) async {
    return await _sessionsApi.getChatsList(request);
  }

  @override
  Future<BaseResponse> hideChat(HideChatRequest request) async {
    return await _sessionsApi.hideChat(request);
  }
}
