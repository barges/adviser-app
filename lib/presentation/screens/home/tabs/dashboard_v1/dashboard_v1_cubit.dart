import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/data/cache/caching_manager.dart';
import 'package:shared_advisor_interface/data/models/reports_endpoint/reports_month.dart';
import 'package:shared_advisor_interface/data/network/responses/reports_response.dart';
import 'package:shared_advisor_interface/domain/repositories/user_repository.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/dashboard_v1/dashboard_v1_state.dart';

class DashboardV1Cubit extends Cubit<DashboardV1State> {
  late final VoidCallback disposeListen;
  final CachingManager cacheManager;

  DashboardV1Cubit(this.cacheManager) : super(const DashboardV1State()) {
    disposeListen = cacheManager.listenUserProfile((value) {
      emit(state.copyWith(userProfile: value));
    });
    getReports();
  }

  final MainCubit mainCubit = Get.find<MainCubit>();
  final UserRepository _userRepository = Get.find<UserRepository>();

  Future<void> getReports() async {
    if (mainCubit.state.internetConnectionIsAvailable) {
      List<ReportsMonth>? months = [];
      final ReportsResponse reportsResponse =
          await _userRepository.getUserReports();
      months = reportsResponse.dateRange?.firstOrNull?.months;

      emit(
        state.copyWith(
            monthAmount:
                months?.firstOrNull?.statistics!.total!.marketTotal?.amount ??
                    0),
      );
    }
  }
}
