import 'package:shared_advisor_interface/data/models/chats/chat_item.dart';
import 'package:shared_advisor_interface/data/network/requests/answer_request.dart';
import 'package:shared_advisor_interface/data/network/responses/conversations_response.dart';
import 'package:shared_advisor_interface/data/network/responses/conversations_story_response.dart';
import 'package:shared_advisor_interface/data/network/responses/history_response.dart';
import 'package:shared_advisor_interface/data/network/responses/questions_list_response.dart';
import 'package:shared_advisor_interface/data/network/responses/rituals_response.dart';

abstract class ChatsRepository {
  Future<QuestionsListResponse> getPublicQuestions({
    required int limit,
    String? lastId,
    String? filtersLanguage,
  });

  Future<QuestionsListResponse> getConversationsList({
    required int limit,
    String? filtersLanguage,
    String? lastItem,
    String? search,
  });

  Future<HistoryResponse> getHistoryList({
    required String clientId,
    required int limit,
    String? lastItem,
    String? storyId,
    String? firstItem,
  });

  Future<ConversationsResponse> getConversationsHistory(
      {required String expertID,
      required String clientID,
      required int offset,
      required int limit});

  Future<ConversationsStoryResponse> getStory({
    required String storyID,
    int? limit,
    String? lastQuestionId,
  });

  Future<QuestionsListResponse> getCustomerSessions({
    required String id,
    required int limit,
    String? lastItem,
    String? filterType,
  });

  Future<ChatItem> takeQuestion(AnswerRequest request);

  Future<ChatItem> returnQuestion(AnswerRequest request);

  Future<ChatItem> getQuestion({required String id});

  Future<RitualsResponse> getRituals({required String id});

  Future<ChatItem> startAnswer(AnswerRequest request);

  Future<ChatItem> sendAnswer(AnswerRequest request);
}
