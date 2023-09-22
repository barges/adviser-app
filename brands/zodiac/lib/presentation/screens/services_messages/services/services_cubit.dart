import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.gr.dart';
import 'package:zodiac/data/models/enums/service_type.dart';
import 'package:zodiac/data/network/requests/delete_service_request.dart';
import 'package:zodiac/data/network/requests/services_list_request.dart';
import 'package:zodiac/data/network/responses/services_response.dart';
import 'package:zodiac/domain/repositories/zodiac_sevices_repository.dart';
import 'package:zodiac/presentation/screens/services_messages/services/services_state.dart';
import 'package:zodiac/zodiac_main_cubit.dart';

@injectable
class ServicesCubit extends Cubit<ServicesState> {
  final ZodiacMainCubit _mainCubit;
  final ZodiacServicesRepository _zodiacServicesRepository;
  late final StreamSubscription<bool> _updateServicesSubscription;

  bool? _hasOfflineServices;
  bool? _hasOnlineServices;

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
    int? status,
    int? index,
    bool refresh = false,
  }) async {
    if (!refresh) {
      emit(state.copyWith(
        selectedStatusIndex: index,
      ));
    }

    try {
      final ServiceResponse response = await _zodiacServicesRepository
          .getServices(ServiceListRequest(status: status));

      final list = response.result?.list;
      if (list != null) {
        _hasOfflineServices ??=
            list.indexWhere((element) => element.type == ServiceType.offline) !=
                -1;

        _hasOnlineServices ??=
            list.indexWhere((element) => element.type == ServiceType.online) !=
                -1;

        emit(state.copyWith(
          services: list,
        ));
      }
    } catch (e) {
      logger.d(e);
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
      route: ZodiacAddService(
          hasOfflineService: _hasOfflineServices == true,
          hasOnlineService: _hasOnlineServices == true),
    );
  }
}
