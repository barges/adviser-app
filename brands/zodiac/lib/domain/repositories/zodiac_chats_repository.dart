import 'package:zodiac/data/network/requests/list_request.dart';
import 'package:zodiac/data/network/responses/chat_entities_response.dart';

abstract class ZodiacChatsRepository {
  Future<ChatEntitiesResponse> getChatsList(ListRequest request);
}
