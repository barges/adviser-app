import 'package:shared_advisor_interface/data/models/chats/chat_item.dart';
import 'package:shared_advisor_interface/data/network/api/chats_api.dart';
import 'package:shared_advisor_interface/data/network/requests/answer_request.dart';
import 'package:shared_advisor_interface/data/network/responses/conversations_response.dart';
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
  Future<QuestionsListResponse> getPrivateQuestions(
      {String? filtersType, String? filtersLanguage}) async {
    return await _api.getPrivateQuestions(
        filtersType: filtersType, filtersLanguage: filtersLanguage);
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
  Future<ConversationsResponse> getConversationsHystory(
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
  Future<ChatItem> getQuestion({required String id}) async {
    return await _api.getQuestion(id: id);
  }

  @override
  Future<ChatItem> sendAnswer(AnswerRequest request) async {
    return await _api.sendAnswer(request);
  }
}
