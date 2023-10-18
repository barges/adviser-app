import 'package:injectable/injectable.dart';

import '../../domain/repositories/fortunica_chats_repository.dart';
import '../models/chats/chat_item.dart';
import '../network/api/chats_api.dart';
import '../network/requests/answer_request.dart';
import '../network/responses/answer_validation_response.dart';
import '../network/responses/conversations_response.dart';
import '../network/responses/conversations_story_response.dart';
import '../network/responses/history_response.dart';
import '../network/responses/questions_list_response.dart';
import '../network/responses/rituals_response.dart';

@Injectable(as: FortunicaChatsRepository)
class FortunicaChatsRepositoryImpl implements FortunicaChatsRepository {
  final ChatsApi _api;

  FortunicaChatsRepositoryImpl(this._api);

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
  Future<HistoryResponse> getHistoryList({
    required String clientId,
    required int limit,
    String? lastItem,
    String? storyId,
    String? firstItem,
  }) async {
    return await _api.getHistoryList(
      clientId: clientId,
      limit: limit,
      lastItem: lastItem,
      storyId: storyId,
      firstItem: firstItem,
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
  Future<RitualsResponse> getRituals({required String id}) async {
    return await _api.getRituals(id: id);
  }

  @override
  Future<ChatItem> startAnswer(AnswerRequest request) async {
    return await _api.startAnswer(request);
  }

  @override
  Future<ChatItem> sendAnswer(AnswerRequest request) async {
    return await _api.sendAnswer(request);
  }

  @override
  Future<QuestionsListResponse> getCustomerQuestions({
    required String clientId,
    String? filterType,
    String? filterLanguage,
  }) async {
    final QuestionsListResponse response = await _api.getCustomerQuestions(
      id: clientId,
      filterType: filterType,
      filterLanguage: filterLanguage,
    );

    return response;
  }

  @override
  Future<QuestionsListResponse> getCustomerHistoryStories({
    required String id,
    required int limit,
    String? lastItem,
    String? filterType,
    String? filterLanguage,
    String? excludeIds,
  }) async {
    final QuestionsListResponse response = await _api.getCustomerHistoryStories(
      id: id,
      limit: limit,
      lastItem: lastItem,
      filterType: filterType,
      filterLanguage: filterLanguage,
      excludeIds: excludeIds,
    );
    return response;
  }

  @override
  Future<AnswerValidationResponse> getAnswerValidation() async {
    return await _api.getAnswerValidation();
  }
}
