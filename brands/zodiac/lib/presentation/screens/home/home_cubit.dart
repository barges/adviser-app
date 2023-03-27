import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.gr.dart';
import 'package:zodiac/data/cache/zodiac_caching_manager.dart';
import 'package:zodiac/data/network/requests/article_count_request.dart';
import 'package:zodiac/data/network/websocket_manager/websocket_manager.dart';
import 'package:zodiac/domain/repositories/zodiac_articles_repository.dart';
import 'package:zodiac/presentation/screens/home/home_state.dart';
import 'package:zodiac/presentation/screens/home/tabs_types.dart';
import 'package:zodiac/zodiac_main_cubit.dart';

class HomeCubit extends Cubit<HomeState> {
  static final List<TabsTypes> tabsList = [
    TabsTypes.dashboard,
    TabsTypes.articles,
    TabsTypes.sessions,
    TabsTypes.account,
  ];

  final ZodiacArticlesRepository _articlesRepository;
  final ZodiacMainCubit _zodiacMainCubit;

  final ZodiacCachingManager _cacheManager;
  final WebSocketManager _webSocketManager;
  //late final StreamSubscription _userStatusSubscription;
  late final List<PageRouteInfo> routes;

  StreamSubscription<bool>? _updateArticleCountSubscription;

  HomeCubit(
    this._cacheManager,
    this._webSocketManager,
    this._articlesRepository,
    this._zodiacMainCubit,
  ) : super(const HomeState()) {
    routes = tabsList.map((e) => _getPage(e)).toList();
    final String? authToken = _cacheManager.getUserToken();
    final int? userId = _cacheManager.getUid();

    if (authToken != null && userId != null) {
      _webSocketManager.connect(authToken, userId);
    }

    _updateArticleCountSubscription =
        _zodiacMainCubit.articleCountUpdateTrigger.listen(
      (_) async {
        getArticleCount();
      },
    );

    getArticleCount();
  }

  @override
  Future<void> close() async {
    _updateArticleCountSubscription?.cancel();
    return super.close();
  }

  Future<void> getArticleCount() async {
    try {
      final articleCountResponse = await _articlesRepository.getArticleCount(
          request: ArticleCountRequest(update: 0, isBadge: 0));
      emit(state.copyWith(articleCount: articleCountResponse?.count));
    } catch (e) {
      logger.d(e);
    }
  }

  // emit(state.copyWith(userStatus: _cacheManager.getUserStatus()));
  // _userStatusSubscription =
  //     _cacheManager.listenCurrentUserStatusStream((value) {
  //       if (value.status != FortunicaUserStatus.live) {
  //         changeTabIndex(tabsList.indexOf(TabsTypes.account));
  //       }
  //       emit(state.copyWith(userStatus: value));
  //     });

  // @override
  // Future<void> close() {
  //  // _userStatusSubscription.cancel();
  //   return super.close();
  // }

  changeTabIndex(int index) {
    emit(state.copyWith(tabPositionIndex: index));
  }

  PageRouteInfo _getPage(TabsTypes tab) {
    switch (tab) {
      case TabsTypes.dashboard:
        return const ZodiacDashboard();
      case TabsTypes.sessions:
        return const ZodiacChats();
      case TabsTypes.account:
        return const ZodiacAccount();
      case TabsTypes.articles:
        return const ZodiacArticles();
    }
  }
}
