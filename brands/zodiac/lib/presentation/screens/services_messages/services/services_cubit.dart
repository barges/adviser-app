import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:zodiac/data/network/requests/delete_service_request.dart';
import 'package:zodiac/data/network/requests/services_list_request.dart';
import 'package:zodiac/data/network/responses/services_response.dart';
import 'package:zodiac/domain/repositories/zodiac_sevices_repository.dart';
import 'package:zodiac/presentation/screens/services_messages/services/services_state.dart';
import 'package:zodiac/zodiac_main_cubit.dart';

@injectable
class ServicesCubit extends Cubit<ServicesState> {
  int? _selectedStatus;
  final ZodiacMainCubit _mainCubit;
  final ZodiacServicesRepository _zodiacServicesRepository;
  late final StreamSubscription<bool> _updateServicesSubscription;

  ServicesCubit(
    this._mainCubit,
    this._zodiacServicesRepository,
  ) : super(const ServicesState()) {
    _init();
  }

  _init() async {
    _updateServicesSubscription =
        _mainCubit.updateServicesTrigger.listen((_) async {
      getServices();
    });

    getServices();
  }

  @override
  Future<void> close() async {
    _updateServicesSubscription.cancel();
    super.close();
  }

  Future<void> getServices() async {
    try {
      final ServiceResponse response = await _zodiacServicesRepository
          .getServices(ServiceListRequest(status: _selectedStatus));

      if (response.status == true &&
          response.result != null &&
          response.result!.list != null) {
        emit(state.copyWith(
          services: List.of(response.result!.list!),
        ));
      }
    } catch (e) {
      logger.d(e);
    }
  }

  void setStatus(int? status) {
    _selectedStatus = status;
  }

  Future<void> deleteService(int serviceId) async {
    if (await _deleteService(serviceId)) {
      final services = state.services!;
      services
          .removeAt(services.indexWhere((element) => element.id == serviceId));
      emit(state.copyWith(
        services: List.of(services),
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
}
