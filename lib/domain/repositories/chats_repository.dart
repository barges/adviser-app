import 'package:shared_advisor_interface/data/models/chats/chat_item.dart';
import 'package:shared_advisor_interface/data/network/requests/answer_request.dart';
import 'package:shared_advisor_interface/data/network/responses/conversations_response.dart';
import 'package:shared_advisor_interface/data/network/responses/conversations_story_response.dart';
import 'package:shared_advisor_interface/data/network/responses/questions_list_response.dart';

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

  Future<QuestionsListResponse> getHistoryList({
    required int limit,
    required int page,
    String? search,
  });

  Future<ConversationsResponse> getConversationsHistory(
      {required String expertID,
      required String clientID,
      required int offset,
      required int limit});

  Future<ConversationsStoryResponse> getConversationsStory(
      {required String storyID});

  Future<ChatItem> takeQuestion(AnswerRequest request);

  Future<ChatItem> getQuestion({required String id});

  Future<ChatItem> getRitualQuestion({required String id});

  Future<dynamic> startAnswer(AnswerRequest request);

  Future<ChatItem> sendAnswer(AnswerRequest request);
}
