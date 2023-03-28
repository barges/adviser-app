import 'dart:async';

import 'package:shared_advisor_interface/infrastructure/routing/app_router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortunica/data/cache/fortunica_caching_manager.dart';
import 'package:fortunica/data/models/enums/fortunica_user_status.dart';
import 'package:fortunica/presentation/screens/home/home_state.dart';
import 'package:fortunica/presentation/screens/home/tabs_types.dart';

class HomeCubit extends Cubit<HomeState> {
  static final List<TabsTypes> tabsList = [
    TabsTypes.dashboard,
    TabsTypes.sessions,
    TabsTypes.account,
  ];

  final FortunicaCachingManager _cacheManager;
  final TabsTypes? _initTab;
  late final StreamSubscription _userStatusSubscription;
  late final List<PageRouteInfo> routes;

  HomeCubit(this._cacheManager, this._initTab) : super(const HomeState()) {
    routes = tabsList.map((e) => _getPage(e)).toList();

    if (_initTab != null && tabsList.contains(_initTab)) {
      Future.delayed(const Duration(seconds: 1)).then((value) {
        changeTabIndex(
          tabsList.indexOf(_initTab!),
        );
      });
    }

    emit(state.copyWith(userStatus: _cacheManager.getUserStatus()));
    _userStatusSubscription =
        _cacheManager.listenCurrentUserStatusStream((value) {
      if (value.status != FortunicaUserStatus.live) {
        changeTabIndex(tabsList.indexOf(TabsTypes.account));
      }
      emit(state.copyWith(userStatus: value));
    });
  }

  @override
  Future<void> close() {
    _userStatusSubscription.cancel();
    return super.close();
  }

  changeTabIndex(int index) {
    emit(state.copyWith(tabPositionIndex: index));
  }

  PageRouteInfo _getPage(TabsTypes tab) {
    switch (tab) {
      case TabsTypes.dashboard:
        return const FortunicaDashboard();
      case TabsTypes.sessions:
        return const FortunicaChats();
      case TabsTypes.account:
        return const FortunicaAccount();
    }
  }
}
