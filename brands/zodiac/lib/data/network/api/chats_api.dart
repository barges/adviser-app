import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:zodiac/data/network/requests/hide_chat_request.dart';
import 'package:zodiac/data/network/requests/list_request.dart';
import 'package:zodiac/data/network/responses/base_response.dart';
import 'package:zodiac/data/network/responses/chat_entities_response.dart';

part 'chats_api.g.dart';

@RestApi()
@injectable
abstract class ChatsApi {
  @factoryMethod
  factory ChatsApi(Dio dio) = _ChatsApi;

  @POST('/entities')
  Future<ChatEntitiesResponse> getChatsList(
    @Body() ListRequest request,
  );

  @POST('/entities/hide-chat')
  Future<BaseResponse> hideChat(
    @Body() HideChatRequest request,
  );
}
