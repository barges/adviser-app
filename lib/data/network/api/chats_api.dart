import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:shared_advisor_interface/data/models/chats/chat_item.dart';
import 'package:shared_advisor_interface/data/network/requests/answer_request.dart';
import 'package:shared_advisor_interface/data/network/responses/conversations_response.dart';
import 'package:shared_advisor_interface/data/network/responses/conversations_story_response.dart';
import 'package:shared_advisor_interface/data/network/responses/questions_list_response.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';

part 'chats_api.g.dart';

@RestApi(baseUrl: AppConstants.baseUrlDev)
abstract class ChatsApi {
  factory ChatsApi(Dio dio) = _ChatsApi;

  @GET('/experts/questions/public')
  Future<QuestionsListResponse> getPublicQuestions({
    @Query('limit') required int limit,
    @Query('lastId') String? lastId,
    @Query('filters[language]') String? filterLanguage,
  });

  @GET('/experts/questions/individual')
  Future<QuestionsListResponse> getPrivateQuestions({
    @Query('filters[type]') String? filtersType,
    @Query('filters[language]') String? filtersLanguage,
  });

  @GET('/experts/conversations/history')
  Future<QuestionsListResponse> getHistoryList({
    @Query('limit') required int limit,
    @Query('page') required int page,
    @Query('search') String? search,
  });

  @GET('/v2/users/{expertID}/conversations/{clientID}')
  Future<ConversationsResponse> getConversationsHystory({
    @Path() required String expertID,
    @Path() required String clientID,
    @Query("offset") required int offset,
    @Query("limit") required int limit,
  });

  @GET('/stories')
  Future<ConversationsStoryResponse> getConversationsStory({
    @Query("storyID") required String storyID,
  });

  @GET('/questions/single/{id}')
  Future<ChatItem> getQuestion({
    @Path() required String id,
  });

  @GET('/v1/rituals/single/{id}')
  Future<ChatItem> getRitualQuestion({
    @Path() required String id,
  });

  @POST('/questions/answer/start')
  Future<dynamic> startAnswer(
    @Body() AnswerRequest request,
  );

  @POST('/answers')
  Future<ChatItem> sendAnswer(
    @Body() AnswerRequest request,
  );

  @POST('/questions/take')
  Future<ChatItem> takeQuestion(
    @Body() AnswerRequest request,
  );
}
