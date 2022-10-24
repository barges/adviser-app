import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/data/cache/caching_manager.dart';
import 'package:shared_advisor_interface/data/models/user_info/user_status.dart';
import 'package:shared_advisor_interface/presentation/screens/home/home_state.dart';
import 'package:shared_advisor_interface/presentation/services/fresh_chat_service.dart';

class HomeCubit extends Cubit<HomeState> {
  final CachingManager cacheManager;

  late final VoidCallback disposeListen;

  HomeCubit(this.cacheManager) : super(const HomeState()) {
    Get.find<FreshChatService>().initFreshChat();
    emit(state.copyWith(
        userStatus: cacheManager.getUserStatus() ?? const UserStatus()));
    disposeListen = cacheManager.listenCurrentUserStatus((value) {
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

  changeIndex(int index) {
    emit(state.copyWith(tabPositionIndex: index));
  }
}
