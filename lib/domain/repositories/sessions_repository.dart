import 'package:shared_advisor_interface/data/network/responses/questions_list_response.dart';

abstract class ChatsRepository {
  Future<QuestionsListResponse> getListOfQuestions(
      {String? lastId, required bool isPublicFilter});
}
