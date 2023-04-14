import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:zodiac/data/models/articles/article.dart';
import 'package:zodiac/data/network/requests/list_request.dart';
import 'package:zodiac/data/network/responses/articles_response.dart';
import 'package:zodiac/domain/repositories/zodiac_articles_repository.dart';
import 'package:zodiac/presentation/screens/home/tabs/articles/articles_state.dart';

class ArticlesCubit extends Cubit<ArticlesState> {
  final int _limit = 10;
  int _offset = 0;
  int? _count;
  bool _isLoading = false;
  final ScrollController articlesScrollController = ScrollController();
  final ZodiacArticlesRepository _articlesRepository;
  final List<Article> _articleList = [];

  ArticlesCubit(
    this._articlesRepository,
  ) : super(const ArticlesState()) {
    articlesScrollController.addListener(_scrollControllerListener);
    _loadData();
  }

  @override
  Future<void> close() async {
    articlesScrollController.dispose();
    super.close();
  }

  Future<void> _loadData() async {
    await getArticles();
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
