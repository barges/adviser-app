import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:shared_advisor_interface/infrastructure/di/brand_manager.dart';
import 'package:zodiac/data/models/articles/article.dart';
import 'package:zodiac/data/network/requests/list_request.dart';
import 'package:zodiac/data/network/responses/articles_response.dart';
import 'package:zodiac/domain/repositories/zodiac_articles_repository.dart';
import 'package:zodiac/presentation/screens/home/tabs/articles/articles_state.dart';
import 'package:zodiac/zodiac.dart';
import 'package:zodiac/zodiac_main_cubit.dart';

class ArticlesCubit extends Cubit<ArticlesState> {
  final int _limit = 10;
  int _offset = 0;
  int? _count;
  bool _isLoading = false;
  final ScrollController articlesScrollController = ScrollController();
  final ZodiacArticlesRepository _articlesRepository;
  final ZodiacMainCubit _zodiacMainCubit;
  final BrandManager _brandManager;

  StreamSubscription? _currentBrandSubscription;
  final List<Article> _articleList = [];
  late final StreamSubscription<bool> _updateArticleSubscription;

  ArticlesCubit(
    this._articlesRepository,
    this._zodiacMainCubit,
    this._brandManager,
  ) : super(const ArticlesState()) {
    if (_brandManager.getCurrentBrand().brandAlias == ZodiacBrand.alias) {
      getArticles();
    } else {
      _currentBrandSubscription =
          _brandManager.listenCurrentBrandStream((value) async {
        if (value.brandAlias == ZodiacBrand.alias) {
          await getArticles();
          _currentBrandSubscription?.cancel();
        }
      });
    }

    articlesScrollController.addListener(_scrollControllerListener);
    _updateArticleSubscription = _zodiacMainCubit.articleUpdateTrigger.listen(
      (_) {
        articlesScrollController.jumpTo(0.0);
        getArticles(refresh: true);
      },
    );
    getArticles();
  }

  @override
  Future<void> close() async {
    _updateArticleSubscription.cancel();
    articlesScrollController.dispose();
    _currentBrandSubscription?.cancel();
    super.close();
  }

  void _scrollControllerListener() {
    if (!_isLoading && articlesScrollController.position.extentAfter <= 300) {
      getArticles();
    }
  }

  Future<void> getArticles({bool refresh = false}) async {
    if (!refresh && _count != null && _offset >= _count!) {
      return;
    }

    if (refresh) {
      _articleList.clear();
      _count = null;
      _offset = 0;
    }

    try {
      _isLoading = true;

      final ArticlesResponse? response = await _articlesRepository
          .getArticleList(request: ListRequest(count: _limit, offset: _offset));
      _count = response?.count ?? 0;
      _offset = _offset + _limit;

      _articleList.addAll(response?.result ?? []);

      emit(state.copyWith(
        articleList: List.of(_articleList),
      ));
      _isLoading = false;
    } catch (e) {
      _isLoading = false;
      logger.d(e);
    }
  }

  void markAsRead(int articleId) {
    final List<Article> articleList = List.of(state.articleList!);
    final Article article =
        articleList.firstWhere((article) => article.id == articleId);
    if (!article.isRead) {
      articleList[articleList.indexOf(article)] =
          article.copyWith(isRead: true);
      emit(state.copyWith(
        articleList: articleList,
      ));
    }
  }
}
