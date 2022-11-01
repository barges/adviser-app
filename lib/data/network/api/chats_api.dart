import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:shared_advisor_interface/data/network/responses/questions_list_response.dart';

part 'chats_api.g.dart';

@RestApi()
abstract class ChatsApi {
  factory ChatsApi(Dio dio) = _ChatsApi;

  @GET('/questions/list')
  Future<QuestionsListResponse> getQuestions(
      {@Query("limit") required int limit,
      @Query("lastId") String? lastId,
      @Query('filters[type]') String? filterType});

  // @GET('/rituals/list')
  // Future<RitualsResponse> getListOfRituals(
  //     {@Query("limit") required int limit,
  //     @Query('filters[type]') String? filterType,
  //     @Query('filters[language]') String? filterLanguage});
}