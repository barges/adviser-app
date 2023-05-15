import 'package:zodiac/data/network/requests/hide_chat_request.dart';
import 'package:zodiac/data/network/requests/list_request.dart';
import 'package:zodiac/data/network/responses/base_response.dart';
import 'package:zodiac/data/network/responses/chat_entities_response.dart';

abstract class ZodiacSessionsRepository {
  Future<ChatEntitiesResponse> getChatsList(ListRequest request);

  Future<BaseResponse> hideChat(HideChatRequest request);
}
