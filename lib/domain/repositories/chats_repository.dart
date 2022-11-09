import 'package:shared_advisor_interface/data/models/chats/answer.dart';
import 'package:shared_advisor_interface/data/models/chats/question.dart';
import 'package:shared_advisor_interface/data/network/requests/answer_request.dart';
import 'package:shared_advisor_interface/data/network/responses/conversations_response.dart';
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

  Future<ConversationsResponse> getConversationsHystory(
      {required String expertID,
      required String clientID,
      required int offset,
      required int limit});

  Future<Question> getQuestion({required String id});

  Future<Answer> sendAnswer(
    AnswerRequest request,
  );
}
