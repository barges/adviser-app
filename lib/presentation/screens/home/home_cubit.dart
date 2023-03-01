import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/data/cache/caching_manager.dart';
import 'package:shared_advisor_interface/data/models/enums/fortunica_user_status.dart';
import 'package:shared_advisor_interface/data/models/user_info/user_status.dart';
import 'package:shared_advisor_interface/presentation/resources/app_arguments.dart';
import 'package:shared_advisor_interface/presentation/screens/home/home_state.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs_types.dart';

class HomeCubit extends Cubit<HomeState> {
  static final List<TabsTypes> tabsList = [
    TabsTypes.dashboard,
    // TabsTypes.articles,
    TabsTypes.sessions,
    TabsTypes.account,
  ];

  final CachingManager _cacheManager;

  late final VoidCallback disposeListen;

  HomeCubit(
    this._cacheManager,
  ) : super(const HomeState()) {
    final HomeScreenArguments? arguments = Get.arguments;
    if (arguments?.initTab != null && tabsList.contains(arguments!.initTab)) {
      changeTabIndex(
        tabsList.indexOf(arguments.initTab),
      );
    }

    emit(state.copyWith(userStatus: _cacheManager.getUserStatus()));
    disposeListen = _cacheManager.listenCurrentUserStatus((value) {
      if (value.status != FortunicaUserStatus.live) {
        changeTabIndex(tabsList.indexOf(TabsTypes.account));
      }
      emit(state.copyWith(userStatus: value));
    });
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  Future<void> close() {
    disposeListen.call();
    return super.close();
  }

  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }

  changeTabIndex(int index) {
    emit(state.copyWith(tabPositionIndex: index));
  }
}
