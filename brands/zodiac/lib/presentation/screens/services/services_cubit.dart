import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.gr.dart';
import 'package:zodiac/data/models/enums/service_status.dart';
import 'package:zodiac/data/network/requests/delete_service_request.dart';
import 'package:zodiac/data/network/requests/services_list_request.dart';
import 'package:zodiac/data/network/responses/services_response.dart';
import 'package:zodiac/domain/repositories/zodiac_sevices_repository.dart';
import 'package:zodiac/presentation/screens/services/services_state.dart';
import 'package:zodiac/zodiac_main_cubit.dart';

@injectable
class ServicesCubit extends Cubit<ServicesState> {
  final ZodiacMainCubit _mainCubit;
  final ZodiacServicesRepository _zodiacServicesRepository;
  late final StreamSubscription<bool> _updateServicesSubscription;

  static const List<ServiceStatus> listOfFilters = [
    ServiceStatus.approved,
    ServiceStatus.pending,
    ServiceStatus.rejected
  ];

  ServicesCubit(
    this._mainCubit,
    this._zodiacServicesRepository,
  ) : super(const ServicesState()) {
    _init();
  }

  _init() async {
    _updateServicesSubscription =
        _mainCubit.updateServicesTrigger.listen((_) async {
      getServices(refresh: true);
    });

    getServices();
  }

  @override
  Future<void> close() async {
    _updateServicesSubscription.cancel();
    super.close();
  }

  Future<void> getServices({
    int? index,
    bool refresh = false,
  }) async {
    if (!refresh) {
      if (index != null) {
        emit(state.copyWith(
          selectedStatusIndex: index,
        ));
      }
    }

    try {
      int selectedStatusIndex = state.selectedStatusIndex;

      int? status = selectedStatusIndex > 0
          ? listOfFilters[selectedStatusIndex - 1].toInt
          : null;

      final ServiceResponse response = await _zodiacServicesRepository
          .getServices(ServiceListRequest(status: status));

      final list = response.result?.list;
      if (list != null) {
        emit(state.copyWith(
          services: list,
        ));
      }
    } catch (e) {
      logger.d(e);
    } finally {
      emit(state.copyWith(alreadyTriedToFetchData: true));
    }
  }

  Future<void> deleteService(int serviceId) async {
    if (await _deleteService(serviceId)) {
      final services = List.of(state.services!);
      services
          .removeAt(services.indexWhere((element) => element.id == serviceId));
      emit(state.copyWith(
        services: services,
      ));
    }
  }

  Future<bool> _deleteService(int serviceId) async {
    try {
      final ServiceResponse response = await _zodiacServicesRepository
          .deleteService(DeleteServiceRequest(serviceId: serviceId));

      if (response.status == true) {
        return true;
      }
    } catch (e) {
      logger.d(e);
    }

    return false;
  }

  bool get isDataServices =>
      state.services != null ? state.services!.isNotEmpty : false;

  void goToAddService(BuildContext context) {
    context.push(
      route: const ZodiacAddService(),
    );
  }
}