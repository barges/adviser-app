import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zodiac/data/models/services/service_item.dart';
import 'package:zodiac/data/network/requests/get_service_info_request.dart';
import 'package:zodiac/data/network/responses/get_service_info_response.dart';
import 'package:zodiac/domain/repositories/zodiac_sevices_repository.dart';
import 'package:zodiac/presentation/screens/duplicate_service/duplicate_service_state.dart';

class DuplicateServiceCubit extends Cubit<DuplicateServiceState> {
  final ZodiacServicesRepository servicesRepository;

  final ValueChanged<Map<String, dynamic>> returnCallback;
  final List<ServiceItem> approvedServices;
  final int? oldDuplicatedServiceId;

  DuplicateServiceCubit({
    required this.servicesRepository,
    required this.returnCallback,
    required this.approvedServices,
    this.oldDuplicatedServiceId,
  }) : super(const DuplicateServiceState()) {
    emit(state.copyWith(
        services: approvedServices,
        selectedDuplicatedService: approvedServices
            .indexWhere((element) => element.id == oldDuplicatedServiceId)));
  }

  void search(String text) {
    List<ServiceItem> services =
        approvedServices.where((element) => element.name == text).toList();

    emit(state.copyWith(services: services));
  }

  void selectDuplicatedService(int index) {
    emit(state.copyWith(selectedDuplicatedService: index));
  }

  Future<void> setDuplicateService() async {
    final int? selectedIndex = state.selectedDuplicatedService;
    final List<ServiceItem>? services = state.services;

    if (selectedIndex != null &&
        services?.isNotEmpty == true &&
        services![selectedIndex].id != null) {
      final GetServiceInfoResponse response =
          await servicesRepository.getServiceInfo(
              GetServiceInfoRequest(serviceId: services[selectedIndex].id!));

      if (response.result != null) {
        returnCallback({
          'name': services[selectedIndex].name ?? '',
          'duplicatedService': response.result,
        });
      }
    }
  }
}
