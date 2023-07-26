import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zodiac/data/models/enums/service_type.dart';
import 'package:zodiac/data/models/services/service_info_item.dart';
import 'package:zodiac/data/models/services/service_item.dart';
import 'package:zodiac/data/models/services/service_language_model.dart';
import 'package:zodiac/presentation/screens/duplicate_service/duplicate_service_state.dart';

class DuplicateServiceCubit extends Cubit<DuplicateServiceState> {
  List<ServiceItem> _services = [];
  DuplicateServiceCubit() : super(const DuplicateServiceState()) {
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
    mainLocale: 'en',
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
