import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/data/cache/caching_manager.dart';
import 'package:shared_advisor_interface/data/models/reports_endpoint/reports_month.dart';
import 'package:shared_advisor_interface/data/network/responses/reports_response.dart';
import 'package:shared_advisor_interface/domain/repositories/user_repository.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/dashboard/dashboard_state.dart';
import 'package:shared_advisor_interface/presentation/services/connectivity_service.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final ConnectivityService _connectivityService =
      getIt.get<ConnectivityService>();

  late final VoidCallback disposeListen;
  final CachingManager cacheManager;

  DashboardCubit(this.cacheManager) : super(const DashboardState()) {
    disposeListen = cacheManager.listenUserProfile((value) {
      emit(state.copyWith(userProfile: value));
    });
    getReports();
  }

  final PageController pageController = PageController();
  final MainCubit mainCubit = Get.find<MainCubit>();
  final UserRepository _userRepository = Get.find<UserRepository>();

  @override
  Future<void> close() async {
    disposeListen.call();
    return super.close();
  }

  void updateDashboardPageViewIndex(int index) {
    pageController.jumpToPage(index);
    emit(state.copyWith(dashboardPageViewIndex: index));
  }

  void updateDashboardDateFilterIndex(int index) {
    emit(state.copyWith(dashboardDateFilterIndex: index));
  }

  Future<void> getReports() async {
    if (await _connectivityService.checkConnection()) {
      final List<ReportsMonth> months = [];
      final ReportsResponse reportsResponse =
          await _userRepository.getUserReports();

      emit(
        state.copyWith(
            monthAmount:
                months.firstOrNull?.statistics!.total!.marketTotal?.amount ??
                    0.0),
      );
    }
  }
}
