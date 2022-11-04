import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:shared_advisor_interface/data/network/responses/questions_list_response.dart';

part 'chats_api.g.dart';

@RestApi(baseUrl: 'https://fortunica-backend-for-2268.fortunica.adviqodev.de')
abstract class ChatsApi {
  factory ChatsApi(Dio dio) = _ChatsApi;

  @GET('/experts/questions/public')
  Future<QuestionsListResponse> getPublicQuestions(
      {@Query('limit') required int limit,
      @Query('lastId') String? lastId,
      @Query('filters[language]') String? filterLanguage,});

  @GET('/experts/questions/individual')
  Future<QuestionsListResponse> getPrivateQuestions(
      {@Query('filters[type]') String? filtersType,
      @Query('filters[language]') String? filtersLanguage,});

  @GET('/experts/conversations/history')
  Future<QuestionsListResponse> getHistoryList({
    @Query('limit') required int limit,
    @Query('page') required int page,
    @Query('search') String? search,
  });

}
