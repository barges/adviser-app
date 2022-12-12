import 'package:shared_advisor_interface/data/models/chats/chat_item.dart';
import 'package:shared_advisor_interface/data/network/api/chats_api.dart';
import 'package:shared_advisor_interface/data/network/requests/answer_request.dart';
import 'package:shared_advisor_interface/data/network/responses/conversations_response.dart';
import 'package:shared_advisor_interface/data/network/responses/conversations_story_response.dart';
import 'package:shared_advisor_interface/data/network/responses/questions_list_response.dart';
import 'package:shared_advisor_interface/domain/repositories/chats_repository.dart';

class ChatsRepositoryImpl implements ChatsRepository {
  final ChatsApi _api;

  ChatsRepositoryImpl(this._api);

  @override
  Future<QuestionsListResponse> getPublicQuestions(
      {required int limit, String? lastId, String? filtersLanguage}) async {
    return await _api.getPublicQuestions(
        limit: limit, lastId: lastId, filterLanguage: filtersLanguage);
  }

  @override
  Future<QuestionsListResponse> getConversationsList({
    required int limit,
    String? filtersLanguage,
    String? lastItem,
    String? search,
  }) async {
    return await _api.getConversationsList(
      limit: limit,
      filtersLanguage: filtersLanguage,
      lastItem: lastItem,
      search: search,
    );
  }

  @override
  Future<QuestionsListResponse> getHistoryList({
    required int limit,
    required int page,
    String? search,
  }) async {
    return await _api.getHistoryList(
      limit: limit,
      page: page,
      search: search,
    );
  }

  @override
  Future<ConversationsResponse> getConversationsHistory(
      {required String expertID,
      required String clientID,
      required int offset,
      required int limit}) async {
    return await _api.getConversationsHystory(
      expertID: expertID,
      clientID: clientID,
      offset: offset,
      limit: limit,
    );
  }

  @override
  Future<ConversationsStoryResponse> getStory(
      {required String storyID, int? limit, String? lastQuestionId}) async {
    return await _api.getStory(
      storyID: storyID,
      limit: limit,
      lastQuestionId: lastQuestionId,
    );
  }

  @override
  Future<ChatItem> takeQuestion(AnswerRequest request) async {
    return await _api.takeQuestion(request);
  }

  @override
  Future<ChatItem> returnQuestion(AnswerRequest request) async {
    return await _api.returnQuestion(request);
  }

  @override
  Future<ChatItem> getQuestion({required String id}) async {
    return await _api.getQuestion(id: id);
  }

  @override
  Future<ChatItem> getRitualQuestion({required String id}) async {
    return await _api.getRitualQuestion(id: id);
  }

  @override
  Future<dynamic> startAnswer(AnswerRequest request) async {
    return await _api.startAnswer(request);
  }

  @override
  Future<ChatItem> sendAnswer(AnswerRequest request) async {
    return await _api.sendAnswer(request);
  }

  @override
  Future<QuestionsListResponse> getCustomerSessions(
      {required String id,
      required int limit,
      String? lastItem,
      String? filterType}) async {
    return await _api.getCustomerSessions(
        id: id, limit: limit, lastItem: lastItem, filterType: filterType);
  }
}
