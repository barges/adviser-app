import 'package:injectable/injectable.dart';
import 'package:zodiac/data/network/api/chats_api.dart';
import 'package:zodiac/data/network/requests/list_request.dart';
import 'package:zodiac/data/network/responses/chat_entities_response.dart';
import 'package:zodiac/domain/repositories/zodiac_chats_repository.dart';

@Injectable(as: ZodiacChatsRepository)
class ZodiacChatsRepositoryImpl implements ZodiacChatsRepository {
  final ChatsApi _chatsApi;

  const ZodiacChatsRepositoryImpl(this._chatsApi);

  @override
  Future<ChatEntitiesResponse> getChatsList(ListRequest request) async {
    return await _chatsApi.getChatsList(request);
  }
}
