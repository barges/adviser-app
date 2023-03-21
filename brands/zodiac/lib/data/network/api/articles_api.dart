import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:zodiac/data/network/requests/article_content_request.dart';
import 'package:zodiac/data/network/requests/article_count_request.dart';
import 'package:zodiac/data/network/requests/articles_request.dart';
import 'package:zodiac/data/network/responses/article_content_response.dart';
import 'package:zodiac/data/network/responses/article_count_response.dart';
import 'package:zodiac/data/network/responses/articles_response.dart';

part 'articles_api.g.dart';

@RestApi()
@injectable
abstract class ArticlesApi {
  @factoryMethod
  factory ArticlesApi(Dio dio) = _ArticlesApi;

  @POST('/article-list')
  Future<ArticlesResponse?> getArticleList(
      {@Body() required ArticlesRequest request});

  @POST('/article-view')
  Future<ArticleContentResponse?> getArticleContent(
      {@Body() required ArticleContentRequest request});

  @POST('/article-count')
  Future<ArticleCountResponse?> getArticleCount(
      {@Body() required ArticleCountRequest request});
}
