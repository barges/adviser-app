import 'dart:async';

import 'package:fortunica/data/models/reports_endpoint/reports_month.dart';
import 'package:fortunica/data/models/reports_endpoint/reports_year.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:shared_advisor_interface/services/connectivity_service.dart';
import 'package:collection/collection.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortunica/data/cache/fortunica_caching_manager.dart';
import 'package:fortunica/data/models/reports_endpoint/reports_statistics.dart';
import 'package:fortunica/data/models/user_info/user_profile.dart';
import 'package:fortunica/data/network/responses/reports_response.dart';
import 'package:fortunica/domain/repositories/fortunica_user_repository.dart';
import 'package:fortunica/fortunica_main_cubit.dart';
import 'package:fortunica/presentation/screens/home/tabs/dashboard_v1/dashboard_v1_state.dart';

class DashboardV1Cubit extends Cubit<DashboardV1State> {
  final ConnectivityService _connectivityService;
  final FortunicaMainCubit mainCubit;
  final FortunicaUserRepository _userRepository;
  final FortunicaCachingManager cacheManager;

  late final StreamSubscription _userProfileSubscription;
  late final StreamSubscription _userIdSubscription;

  DashboardV1Cubit(this.cacheManager, this._connectivityService,
      this._userRepository, this.mainCubit)
      : super(const DashboardV1State()) {
    final UserProfile? userProfile = cacheManager.getUserProfile();

    emit(state.copyWith(userProfile: userProfile));
    _userProfileSubscription = cacheManager.listenUserProfileStream((value) {
      logger.d(value);
      emit(state.copyWith(userProfile: value));
    });
    _userIdSubscription = cacheManager.listenUserIdStream((value) {
      if (value != null) {
        getReports();
      }
    });
  }

  @override
  Future<void> close() async {
    _userProfileSubscription.cancel();
    _userIdSubscription.cancel();
    return super.close();
  }

  Future<void> getReports() async {
    try {
      if (await _connectivityService.checkConnection()) {
        final List<ReportsMonth> months = [];

        final ReportsResponse reportsResponse =
            await _userRepository.getUserReports();

        ReportsStatistics? statistics = reportsResponse
            .dateRange?.firstOrNull?.months?.firstOrNull?.statistics;

        for (ReportsYear year in reportsResponse.dateRange ?? []) {
          months.addAll(year.months ?? []);
        }

        emit(
          state.copyWith(
            monthAmount: statistics?.total?.marketTotal?.amount ?? 0.0,
            currencySymbol:
                statistics?.meta?.currency?.currencySymbolByName ?? '',
            months: months,
            reportsStatistics: months.firstOrNull?.statistics,
            currentMonthIndex: 0,
          ),
        );
      }
    } catch (e) {
      logger.d(e);
    }
  }

  Future<void> updateStatisticsByMonth(int index) async {
    if (index > 0) {
      final ReportsStatistics reportsStatistics =
          await _userRepository.getUserReportsByMonth(
        state.months[index].startDate ?? '',
        state.months[index].endDate ?? '',
      );

      emit(state.copyWith(reportsStatistics: reportsStatistics));
    } else {
      emit(state.copyWith(
        reportsStatistics: state.months.firstOrNull?.statistics,
      ));
    }
  }

  void updateCurrentMonthIndex(int index) {
    emit(state.copyWith(currentMonthIndex: index));
    updateStatisticsByMonth(index);
  }

  Future<void> refreshInfo() async {
    mainCubit.updateAccount();
    getReports();
  }

  void closeErrorWidget() {
    mainCubit.clearErrorMessage();
  }
}
