import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/data/cache/caching_manager.dart';
import 'package:shared_advisor_interface/data/models/enums/fortunica_user_status.dart';
import 'package:shared_advisor_interface/data/models/user_info/user_status.dart';
import 'package:shared_advisor_interface/data/network/requests/set_push_notification_token_request.dart';
import 'package:shared_advisor_interface/domain/repositories/user_repository.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/presentation/resources/app_arguments.dart';
import 'package:shared_advisor_interface/presentation/screens/home/home_state.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs_types.dart';
import 'package:shared_advisor_interface/presentation/services/connectivity_service.dart';
import 'package:shared_advisor_interface/presentation/services/push_notification/push_notification_manager.dart';

class HomeCubit extends Cubit<HomeState> {
  static final List<TabsTypes> tabsList = [
    TabsTypes.dashboard,
    // TabsTypes.articles,
    TabsTypes.sessions,
    TabsTypes.account,
  ];

  final CachingManager cacheManager;
  final BuildContext context;

  final ConnectivityService _connectivityService =
      getIt.get<ConnectivityService>();

  final UserRepository _userRepository = getIt.get<UserRepository>();
  final PushNotificationManager _pushNotificationManager =
      getIt.get<PushNotificationManager>();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  late final VoidCallback disposeListen;

  HomeCubit({
    required this.cacheManager,
    required this.context,
  }) : super(const HomeState()) {
    final HomeScreenArguments? arguments = Get.arguments;
    if (arguments?.initTab != null && tabsList.contains(arguments!.initTab)) {
      changeTabIndex(
        tabsList.indexOf(arguments.initTab),
      );
    }

    emit(state.copyWith(
        userStatus: cacheManager.getUserStatus() ?? const UserStatus()));
    disposeListen = cacheManager.listenCurrentUserStatus((value) {
      if (value.status != FortunicaUserStatus.live) {
        changeTabIndex(tabsList.indexOf(TabsTypes.account));
      }
      emit(state.copyWith(userStatus: value));
    });
    _pushNotificationManager.registerForPushNotifications();
    _sendPushToken();
  }

  StreamSubscription<bool>? _connectivitySubscription;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    disposeListen.call();
    return super.close();
  }

  Future<void> _sendPushToken() async {
    if (await _connectivityService.checkConnection()) {
      String? pushToken = await _firebaseMessaging.getToken();
      if (pushToken != null) {
        final SetPushNotificationTokenRequest request =
            SetPushNotificationTokenRequest(
          pushToken: pushToken,
        );
        _userRepository.sendPushToken(request);
      }
      _connectivitySubscription?.cancel();
    } else {
      _connectivitySubscription =
          _connectivityService.connectivityStream.listen((event) {
        if (event) {
          _sendPushToken();
        }
      });
    }
  }

  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }

  changeTabIndex(int index) {
    emit(state.copyWith(tabPositionIndex: index));
  }
}
