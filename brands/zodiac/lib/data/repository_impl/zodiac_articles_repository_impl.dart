import 'package:injectable/injectable.dart';
import 'package:zodiac/data/network/api/articles_api.dart';
import 'package:zodiac/data/network/requests/article_content_request.dart';
import 'package:zodiac/data/network/requests/article_count_request.dart';
import 'package:zodiac/data/network/requests/articles_request.dart';
import 'package:zodiac/data/network/responses/article_content_response.dart';
import 'package:zodiac/data/network/responses/article_count_response.dart';
import 'package:zodiac/data/network/responses/articles_response.dart';
import 'package:zodiac/domain/repositories/zodiac_articles_repository.dart';

@Injectable(as: ZodiacArticlesRepository)
class ZodiacAuthRepositoryImpl implements ZodiacArticlesRepository {
  final ArticlesApi _api;

  ZodiacAuthRepositoryImpl(this._api);

  @override
  Future<ArticlesResponse?> getArticleList(
      {required ArticlesRequest request}) async {
    return await _api.getArticleList(request: request);
  }

  @override
  Future<ArticleContentResponse?> getArticleContent(
      {required ArticleContentRequest request}) async {
    return await _api.getArticleContent(request: request);
  }

  @override
  Future<ArticleCountResponse?> getArticleCount(
      {required ArticleCountRequest request}) async {
    return await _api.getArticleCount(request: request);
  }
}
