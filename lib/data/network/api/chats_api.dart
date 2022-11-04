import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:shared_advisor_interface/data/models/chats/answer.dart';
import 'package:shared_advisor_interface/data/models/chats/question.dart';
import 'package:shared_advisor_interface/data/network/requests/answer_request.dart';
import 'package:shared_advisor_interface/data/network/responses/conversations_response.dart';
import 'package:shared_advisor_interface/data/network/responses/questions_list_response.dart';

part 'chats_api.g.dart';

@RestApi(baseUrl: 'https://fortunica-backend-for-2268.fortunica.adviqodev.de/')
abstract class ChatsApi {
  factory ChatsApi(Dio dio) = _ChatsApi;

  @GET('/questions/list')
  Future<QuestionsListResponse> getQuestions(
      {@Query("limit") required int limit,
      @Query("lastId") String? lastId,
      @Query('filters[type]') String? filterType});

  @GET('/v2/users/{expertID}/conversations/{clientID}')
  Future<ConversationsResponse> getConversationsHystory({
    @Path() required String expertID,
    @Path() required String clientID,
    @Query("offset") required int offset,
    @Query("limit") required int limit,
  });

  @GET('questions/single/{id}')
  Future<Question> getQuestion({
    @Path() required String id,
  });

  @POST('/answers')
  Future<Answer> sendAnswer(
    @Body() AnswerRequest request,
  );

  // @GET('/rituals/list')
  // Future<RitualsResponse> getListOfRituals(
  //     {@Query("limit") required int limit,
  //     @Query('filters[type]') String? filterType,
  //     @Query('filters[language]') String? filterLanguage});
}
