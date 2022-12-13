import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/data/cache/caching_manager.dart';
import 'package:shared_advisor_interface/data/models/reports_endpoint/reports_statistics.dart';
import 'package:shared_advisor_interface/data/network/responses/reports_response.dart';
import 'package:shared_advisor_interface/domain/repositories/user_repository.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/dashboard_v1/dashboard_v1_state.dart';
import 'package:shared_advisor_interface/presentation/services/connectivity_service.dart';

class DashboardV1Cubit extends Cubit<DashboardV1State> {
  final ConnectivityService _connectivityService = ConnectivityService();

  late final VoidCallback disposeUserProfileListen;
  late final VoidCallback disposeUserIdListen;
  final CachingManager cacheManager;

  DashboardV1Cubit(this.cacheManager) : super(const DashboardV1State()) {
    disposeUserProfileListen = cacheManager.listenUserProfile((value) {
      emit(state.copyWith(userProfile: value));
    });
    disposeUserIdListen = cacheManager.listenUserId((value) {
      if (value != null) {
        getReports();
      }
    });
  }

  final MainCubit mainCubit = getIt.get<MainCubit>();
  final UserRepository _userRepository = getIt.get<UserRepository>();

  @override
  Future<void> close() async {
    disposeUserProfileListen.call();
    disposeUserIdListen.call();
    return super.close();
  }

  Future<void> getReports() async {
    if (await _connectivityService.checkConnection()) {
      final ReportsResponse reportsResponse =
          await _userRepository.getUserReports();
      ReportsStatistics? statistics = reportsResponse
          .dateRange?.firstOrNull?.months?.firstOrNull?.statistics;
      emit(
        state.copyWith(
            monthAmount: statistics?.total?.marketTotal?.amount ?? 0.0,
            currencySymbol:
                statistics?.meta?.currency?.currencySymbolByName ?? ''),
      );
    }
  }
}
