import 'package:shared_advisor_interface/data/network/api/chats_api.dart';
import 'package:shared_advisor_interface/data/network/responses/questions_list_response.dart';
import 'package:shared_advisor_interface/domain/repositories/sessions_repository.dart';

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
}
