import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:zodiac/data/models/articles/article_content.dart';
import 'package:zodiac/data/network/requests/article_content_request.dart';

import 'package:zodiac/data/network/responses/article_content_response.dart';

import 'package:zodiac/domain/repositories/zodiac_articles_repository.dart';
import 'package:zodiac/presentation/screens/article_detail_screen/article_details_state.dart';
import 'package:zodiac/zodiac_main_cubit.dart';

class ArticleDetailsCubit extends Cubit<ArticleDetailsState> {
  final ZodiacArticlesRepository _articlesRepository;
  final ZodiacMainCubit _mainCubit;
  final int _articleId;

  ArticleDetailsCubit(
    this._articlesRepository,
    this._mainCubit,
    this._articleId,
  ) : super(const ArticleDetailsState()) {
    getArticleContent(_articleId)
        .then((value) => _mainCubit.updateArticleCount());
  }

  Future<void> getArticleContent(int articleId) async {
    try {
      final ArticleContentResponse? response =
          await _articlesRepository.getArticleContent(
              request: ArticleContentRequest(articleId: articleId));

      ArticleContent? result = response?.result;

      emit(
        state.copyWith(
          articleContent: result,
        ),
      );
    } catch (e) {
      logger.d(e);
    }
  }
}
