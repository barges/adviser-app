import 'package:zodiac/data/network/requests/chat_entities_request.dart';
import 'package:zodiac/data/network/responses/chat_entities_response.dart';

abstract class ChatsRepository {
  Future<ChatEntitiesResponse> getChatsList(ChatEntitiesRequest request);
}
