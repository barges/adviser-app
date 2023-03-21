import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:zodiac/data/network/requests/chat_entities_request.dart';
import 'package:zodiac/data/network/responses/chat_entities_response.dart';

part 'chats_api.g.dart';

@RestApi()
@injectable
abstract class ChatsApi {
  @factoryMethod
  factory ChatsApi(Dio dio) = _ChatsApi;

  @POST('/entities')
  Future<ChatEntitiesResponse> getChatsList(
    @Body() ChatEntitiesRequest request,
  );
}
