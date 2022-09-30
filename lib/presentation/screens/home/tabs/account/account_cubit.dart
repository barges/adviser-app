import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/data/models/user_info/user_info.dart';
import 'package:shared_advisor_interface/domain/repositories/user_repository.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/account/account_state.dart';
import 'package:shared_advisor_interface/extensions.dart';

class AccountCubit extends Cubit<AccountState> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  final TextEditingController searchController = TextEditingController();

  final UserRepository userRepository = Get.find<UserRepository>();

  AccountCubit() : super(const AccountState()) {
    getUserinfo();
  }

  Future<void> getUserinfo() async {
    final UserInfo userInfo = await userRepository.getUserInfo();
    emit(state.copyWith(
        avatarUrl: userInfo.profile?.profilePictures?.firstOrNull));
  }

  void updateIsAvailableValue(bool newValue) {
    emit(state.copyWith(isAvailable: newValue));
  }

  void updateEnableNotificationsValue(bool newValue) {
    emit(state.copyWith(enableNotifications: newValue));
  }
}
