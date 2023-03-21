import 'package:injectable/injectable.dart';
import 'package:zodiac/data/network/api/chats_api.dart';
import 'package:zodiac/data/network/responses/chat_entities_response.dart';
import 'package:zodiac/data/network/requests/chat_entities_request.dart';
import 'package:zodiac/domain/repositories/chats_repository.dart';

@Injectable(as: ChatsRepository)
class ChatsRepositoryImpl implements ChatsRepository {
  final ChatsApi _chatsApi;

  const ChatsRepositoryImpl(this._chatsApi);

  @override
  Future<ChatEntitiesResponse> getChatsList(ChatEntitiesRequest request) async {
    return await _chatsApi.getChatsList(request);
  }
}
