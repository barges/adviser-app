import 'package:shared_advisor_interface/data/network/responses/questions_list_response.dart';

abstract class SessionsRepository {
  Future<QuestionsListResponse> getListOfQuestions(
      {int page = 0,required bool isPublicFilter});
}
