import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:shared_advisor_interface/data/network/responses/questions_list_response.dart';
import 'package:shared_advisor_interface/data/network/responses/rituals_response.dart';

part 'sessions_api.g.dart';

@RestApi()
abstract class SessionsApi {
  factory SessionsApi(Dio dio) = _SessionsApi;

  @GET('/questions/list')
  Future<QuestionsListResponse> getListOfQuestions(
      {@Query("page") required int page,
      @Query("limit") required int limit,
      @Query('filters[type]') String? filterType});

  @GET('/rituals/list')
  Future<RitualsResponse> getListOfRituals(
      {@Query("page") required int page,
        @Query("limit") required int limit,
        @Query('filters[type]') String? filterType,
        @Query('filters[language]') String? filterLanguage});

}
