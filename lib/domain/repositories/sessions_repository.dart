import 'package:shared_advisor_interface/data/network/responses/questions_list_response.dart';

abstract class ChatsRepository {
  Future<QuestionsListResponse> getPublicQuestions({
    required int limit,
    String? lastId,
    String? filtersLanguage,
  });

  Future<QuestionsListResponse> getPrivateQuestions({
    String? filtersType,
    String? filtersLanguage,
  });

  Future<QuestionsListResponse> getHistoryList({
    required int limit,
    required int page,
    String? search,
  });
}
