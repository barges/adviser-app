import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zodiac/data/models/enums/service_type.dart';
import 'package:zodiac/data/models/services/service_info_item.dart';
import 'package:zodiac/data/models/services/service_item.dart';
import 'package:zodiac/data/models/services/service_language_model.dart';
import 'package:zodiac/presentation/screens/duplicate_service/duplicate_service_state.dart';

class DuplicateServiceCubit extends Cubit<DuplicateServiceState> {
  final ValueChanged<Map<String, dynamic>> returnCallback;

  List<ServiceItem> _services = [];

  DuplicateServiceCubit({required this.returnCallback})
      : super(const DuplicateServiceState()) {
    _getDuplicatedServices();
  }

  void _getDuplicatedServices() {
    _services = const [
      ServiceItem(id: 1, name: 'Karma Cleaning'),
      ServiceItem(id: 2, name: 'Tarrot Reading'),
    ];

    emit(state.copyWith(services: _services));
  }

  void search(String text) {
    List<ServiceItem> services =
        _services.where((element) => element.name == text).toList();

    emit(state.copyWith(services: services));
  }

  void selectDuplicatedService(int index) {
    emit(state.copyWith(selectedDuplicatedService: index));
  }

  void setDuplicateService() {
    final int? selectedIndex = state.selectedDuplicatedService;
    final List<ServiceItem>? services = state.services;

    if (selectedIndex != null && services != null) {
      final ServiceInfoItem service = servicesInfo
          .firstWhere((element) => element.id == services[selectedIndex].id);
      returnCallback({
        'name': services[selectedIndex].name ?? '',
        'duplicatedService': service,
      });
    }
  }
}

List<ServiceInfoItem> servicesInfo = const [
  ServiceInfoItem(
    id: 1,
    image:
        'https://upload.wikimedia.org/wikipedia/commons/b/b6/Image_created_with_a_mobile_phone.png',
    mainLocale: 'en',
    type: ServiceType.offline,
    translations: [
      ServiceLanguageModel(
        code: 'en',
        title: 'Karma cleaning EN',
        description: 'Some description EN',
      ),
      ServiceLanguageModel(
        code: 'es',
        title: 'Karma cleaning ES',
        description: 'Some description ES',
      )
    ],
    price: 19.99,
    duration: 1800,
    discount: 10,
  ),
  ServiceInfoItem(
    id: 2,
    image:
        'https://upload.wikimedia.org/wikipedia/commons/b/b6/Image_created_with_a_mobile_phone.png',
    mainLocale: 'es',
    type: ServiceType.offline,
    translations: [
      ServiceLanguageModel(
        code: 'en',
        title: 'Tarrot Reading EN',
        description: 'Some description EN',
      ),
      ServiceLanguageModel(
        code: 'es',
        title: 'Tarrot Reading ES',
        description: 'Some description ES',
      )
    ],
    price: 19.99,
    duration: 1800,
    discount: 10,
  ),
];
