import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:shared_advisor_interface/services/connectivity_service.dart';
import 'package:zodiac/data/models/articles/article_content.dart';
import 'package:zodiac/data/network/requests/article_content_request.dart';

import 'package:zodiac/data/network/responses/article_content_response.dart';

import 'package:zodiac/domain/repositories/zodiac_articles_repository.dart';
import 'package:zodiac/presentation/screens/article_details_screen/article_details_state.dart';

class ArticleDetailsCubit extends Cubit<ArticleDetailsState> {
  final ZodiacArticlesRepository _articlesRepository;
  final ConnectivityService _connectivityService;
  final int _articleId;

  late final StreamSubscription _connectivitySubscription;

  bool _firstLoad = true;

  ArticleDetailsCubit(
    this._articlesRepository,
    this._connectivityService,
    this._articleId,
  ) : super(const ArticleDetailsState()) {
    _connectivitySubscription = _connectivityService.connectivityStream.listen(
      (event) {
        if (event && _firstLoad) {
          getArticleContent(_articleId);
        }
      },
    );

    getArticleContent(_articleId);
  }

  @override
  Future<void> close() async {
    _connectivitySubscription.cancel();
    super.close();
  }

  Future<void> getArticleContent(int articleId) async {
    try {
      if (await _connectivityService.checkConnection()) {
        final ArticleContentResponse? response =
            await _articlesRepository.getArticleContent(
                request: ArticleContentRequest(articleId: articleId));

        ArticleContent? result = response?.result;

        emit(
          state.copyWith(
            articleContent: result,
          ),
        );
        _firstLoad = false;
      }
    } catch (e) {
      logger.d(e);
    }
  }
}
