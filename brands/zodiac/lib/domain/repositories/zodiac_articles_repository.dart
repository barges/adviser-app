import 'package:zodiac/data/network/requests/article_content_request.dart';
import 'package:zodiac/data/network/requests/article_count_request.dart';
import 'package:zodiac/data/network/requests/articles_request.dart';
import 'package:zodiac/data/network/responses/article_content_response.dart';
import 'package:zodiac/data/network/responses/article_count_response.dart';
import 'package:zodiac/data/network/responses/articles_response.dart';

abstract class ZodiacArticlesRepository {
  Future<ArticlesResponse?> getArticleList({required ArticlesRequest request});

  Future<ArticleContentResponse?> getArticleContent(
      {required ArticleContentRequest request});

  Future<ArticleCountResponse?> getArticleCount(
      {required ArticleCountRequest request});
}
