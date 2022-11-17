import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/data/cache/caching_manager.dart';
import 'package:shared_advisor_interface/data/models/user_info/user_status.dart';
import 'package:shared_advisor_interface/data/network/requests/set_push_notification_token_request.dart';
import 'package:shared_advisor_interface/domain/repositories/user_repository.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/presentation/screens/home/home_state.dart';
import 'package:shared_advisor_interface/presentation/services/connectivity_service.dart';
import 'package:shared_advisor_interface/presentation/services/fresh_chat_service.dart';
import 'package:shared_advisor_interface/presentation/services/push_notification/push_notification_manager.dart';

class HomeCubit extends Cubit<HomeState> {
  final CachingManager cacheManager;
  final BuildContext context;

  final ConnectivityService _connectivityService = ConnectivityService();

  final UserRepository _userRepository = getIt.get<UserRepository>();
  final PushNotificationManager _pushNotificationManager =
      getIt.get<PushNotificationManager>();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  late final VoidCallback disposeListen;

  HomeCubit(this.cacheManager, this.context) : super(const HomeState()) {
    getIt.get<FreshChatService>().initFreshChat(context);
    emit(state.copyWith(
        userStatus: cacheManager.getUserStatus() ?? const UserStatus()));
    disposeListen = cacheManager.listenCurrentUserStatus((value) {
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
    if (await ConnectivityService.checkConnection()) {
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

  changeIndex(int index) {
    emit(state.copyWith(tabPositionIndex: index));
  }
}
