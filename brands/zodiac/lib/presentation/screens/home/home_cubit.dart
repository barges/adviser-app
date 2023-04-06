import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.gr.dart';
import 'package:zodiac/data/cache/zodiac_caching_manager.dart';
import 'package:zodiac/data/models/enums/zodiac_user_status.dart';
import 'package:zodiac/data/models/user_info/locale_model.dart';
import 'package:zodiac/data/network/requests/article_count_request.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';
import 'package:zodiac/data/network/responses/locales_response.dart';
import 'package:zodiac/domain/repositories/zodiac_user_repository.dart';
import 'package:zodiac/services/websocket_manager/websocket_manager.dart';
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
  final ZodiacUserRepository _userRepository;

  final ZodiacCachingManager _cacheManager;
  final ZodiacMainCubit _mainCubit;
  final WebSocketManager _webSocketManager;
  late final StreamSubscription _userStatusSubscription;
  late final StreamSubscription<bool> _updateArticleCountSubscription;
  late final List<PageRouteInfo> routes;
  bool _firstOpenArticlesTab = true;

  HomeCubit(
    this._cacheManager,
    this._mainCubit,
    this._webSocketManager,
    this._articlesRepository,
    this._userRepository,
  ) : super(const HomeState()) {
    routes = tabsList.map((e) => _getPage(e)).toList();
    _webSocketManager.connect();

    checkAndSaveAllLocales();

    emit(
      state.copyWith(
        userStatus: _cacheManager.getUserStatus() ?? ZodiacUserStatus.offline,
      ),
    );

    _userStatusSubscription =
        _cacheManager.listenCurrentUserStatusStream((value) {
      emit(state.copyWith(userStatus: value));
    });

    _updateArticleCountSubscription =
        _mainCubit.articleCountUpdateTrigger.listen(
      (_) async {
        getArticleCount(update: 1);
      },
    );

    getArticleCount();
  }

  Future<void> checkAndSaveAllLocales() async {
     if (!_cacheManager.haveLocales) {
      final LocalesResponse response =
          await _userRepository.getPreferredLocales(AuthorizedRequest());
      if (response.status == true) {
        List<LocaleModel>? locales = response.result;
        if (locales?.isNotEmpty == true) {
          _cacheManager.saveAllLocales(locales!);
        }
      }
     }
  }

  Future<void> getArticleCount({update = 0}) async {
    try {
      final articleCountResponse = await _articlesRepository.getArticleCount(
          request: ArticleCountRequest(update: update, isBadge: 1));
      emit(state.copyWith(articlesUnreadCount: articleCountResponse?.count));
    } catch (e) {
      logger.d(e);
    }
  }

  @override
  Future<void> close() {
    _updateArticleCountSubscription.cancel();
    _userStatusSubscription.cancel();
    return super.close();
  }

  changeTabIndex(int index) {
    emit(state.copyWith(tabPositionIndex: index));
    if (_firstOpenArticlesTab && index == TabsTypes.articles.index) {
      getArticleCount(update: 1);
      _firstOpenArticlesTab = false;
    }
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
