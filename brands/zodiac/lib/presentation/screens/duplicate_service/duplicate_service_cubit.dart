import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zodiac/presentation/screens/duplicate_service/duplicate_service_state.dart';

class DuplicateServiceCubit extends Cubit<DuplicateServiceState> {
  List<String> _services = [];
  DuplicateServiceCubit() : super(const DuplicateServiceState()) {
    _getDuplicatedServices();
  }

  void _getDuplicatedServices() {
    _services = [
      'Karma cleaning',
      'Tarrot Reading',
      'Love & Relationship',
      'Astral Chart',
      'Aura cleaning',
    ];

    emit(state.copyWith(services: _services));
  }

  void search(String text) {
    List<String> services = _services
        .where(
            (element) => element.toLowerCase().startsWith(text.toLowerCase()))
        .toList();

    emit(state.copyWith(services: services));
  }

  void selectDuplicatedService(int index) {
    emit(state.copyWith(selectedDuplicatedService: index));
  }
}
