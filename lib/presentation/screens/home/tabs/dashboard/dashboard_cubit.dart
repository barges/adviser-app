import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/dashboard/dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit() : super(const DashboardState());

  final PageController pageController = PageController();

  void updateDashboardPageViewIndex(int index) {
    pageController.jumpToPage(index);
    emit(state.copyWith(dashboardPageViewIndex: index));
  }

  void updateDashboardDateFilterIndex(int index) {
    emit(state.copyWith(dashboardDateFilterIndex: index));
  }
}
