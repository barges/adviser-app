import 'package:shared_advisor_interface/data/models/chats/answer.dart';
import 'package:shared_advisor_interface/data/models/chats/question.dart';
import 'package:shared_advisor_interface/data/network/api/chats_api.dart';
import 'package:shared_advisor_interface/data/network/requests/answer_request.dart';
import 'package:shared_advisor_interface/data/network/responses/conversations_response.dart';
import 'package:shared_advisor_interface/data/network/responses/questions_list_response.dart';
import 'package:shared_advisor_interface/domain/repositories/chats_repository.dart';

class ChatsRepositoryImpl implements ChatsRepository {
  final ChatsApi _api;

  ChatsRepositoryImpl(this._api);

  static const int _limit = 10;

  @override
  Future<QuestionsListResponse> getListOfQuestions(
      {String? lastId, required bool isPublicFilter}) async {
    return await _api.getQuestions(
        limit: _limit,
        lastId: lastId,
        filterType: buildFilterType(isPublicFilter));
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
  Future<Question> getQuestion({required String id}) async {
    return await _api.getQuestion(id: id);
  }

  @override
  Future<Answer> sendAnswer(AnswerRequest request) async {
    return await _api.sendAnswer(request);
  }

  String buildFilterType(bool isPublicFilter) {
    if (isPublicFilter) {
      return 'PUBLIC';
    } else {
      return 'PRIVATE';
    }
  }
}
