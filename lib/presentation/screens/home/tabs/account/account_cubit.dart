import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/account/account_state.dart';

class AccountCubit extends Cubit<AccountState> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  final TextEditingController searchController = TextEditingController();

  AccountCubit() : super(const AccountState());

  void updateIsAvailableValue(bool newValue) {
    emit(state.copyWith(isAvailable: newValue));
  }

  void updateEnableNotificationsValue(bool newValue) {
    emit(state.copyWith(enableNotifications: newValue));
  }
}
