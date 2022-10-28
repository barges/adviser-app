import 'package:shared_advisor_interface/data/network/responses/questions_list_response.dart';

abstract class SessionsRepository {
  Future<QuestionsListResponse> getListOfQuestions(
      {String? lastId, required bool isPublicFilter});

  Future<dynamic> getQuestionsHistory(
      {required String expertID,
      required String clientID,
      required int offset,
      required int limit});
}
