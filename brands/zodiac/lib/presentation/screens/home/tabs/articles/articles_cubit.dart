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

class ArticlesCubit extends Cubit<ArticlesState> {
  final int _limit = 10;
  int _offset = 0;
  int? _count;
  bool _isLoading = false;
  final ScrollController articlesScrollController = ScrollController();
  final ZodiacArticlesRepository _articlesRepository;
  final BrandManager _brandManager;

  StreamSubscription? _currentBrandSubscription;

  ArticlesCubit(
    this._articlesRepository,
    this._brandManager,
  ) : super(const ArticlesState()) {

    if (_brandManager.getCurrentBrand().brandAlias == ZodiacBrand.alias) {
      _loadData();
    } else {
      _currentBrandSubscription =
          _brandManager.listenCurrentBrandStream((value) async {
            if(value.brandAlias == ZodiacBrand.alias) {
              await _loadData();
              _currentBrandSubscription?.cancel();
            }
          });
    }

    articlesScrollController.addListener(_scrollControllerListener);

  }

  @override
  Future<void> close() async {
    articlesScrollController.dispose();
    _currentBrandSubscription?.cancel();
    super.close();
  }

  Future<void> _loadData() async {
    await getArticles();
    WidgetsBinding.instance.scheduleFrameCallback((_) {
      if (articlesScrollController.hasClients) {
        _checkIfNeedAndLoadData();
      }
    });
  }

  void _scrollControllerListener() {
    _checkIfNeedAndLoadData();
  }

  void _checkIfNeedAndLoadData() {
    if (!_isLoading && articlesScrollController.position.extentAfter <= 300) {
      getArticles();
    }
  }

  Future<void> getArticles({bool refresh = false}) async {
    if (!refresh && _count != null && _offset >= _count!) {
      return;
    }

    try {
      _isLoading = true;

      _offset = refresh ? 0 : _offset;
      final ArticlesResponse? response =
          await _articlesRepository.getArticleList(
              request: ListRequest(count: _limit, offset: _offset));
      List<Article>? result = response?.result ?? [];
      _count = response?.count ?? 0;
      _offset = _offset + _limit;

      final List<Article> articleList =
          refresh ? <Article>[] : List.of(state.articleList);
      articleList.addAll(result);

      emit(state.copyWith(
        articleList: articleList,
      ));
      _isLoading = false;
    } catch (e) {
      _isLoading = false;
      logger.d(e);
    }
  }

  void markAsRead(int articleId) {
    final List<Article> articleList = List.of(state.articleList);
    final Article article =
        articleList.firstWhere((article) => article.id == articleId);
    if (!article.isRead) {
      final Article articleAsRead = article.copyWith(isRead: true);
      final replaceIndex = articleList.indexOf(article);
      articleList.replaceRange(replaceIndex, replaceIndex + 1, [articleAsRead]);
      emit(state.copyWith(
        articleList: articleList,
      ));
    }
  }
}
