import 'package:shared_advisor_interface/data/network/api/sessions_api.dart';
import 'package:shared_advisor_interface/data/network/responses/questions_list_response.dart';
import 'package:shared_advisor_interface/domain/repositories/sessions_repository.dart';

class SessionsRepositoryImpl implements SessionsRepository {
  final SessionsApi _api;

  SessionsRepositoryImpl(this._api);

  static const int _limit = 10;

  @override
  Future<QuestionsListResponse> getListOfQuestions(
      {int page = 0, required bool isPublicFilter}) async {
    return await _api.getListOfQuestions(
        limit: _limit + page,
        page: page,
        filterType: buildFilterType(isPublicFilter));
  }

  String buildFilterType(bool isPublicFilter) {
    if (isPublicFilter) {
      return 'PUBLIC';
    } else {
      return 'PRIVATE';
    }
  }
}
