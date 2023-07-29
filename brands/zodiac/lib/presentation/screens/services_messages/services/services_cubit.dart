import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:zodiac/data/models/services/service_item.dart';
import 'package:zodiac/data/network/requests/services_list_request.dart';
import 'package:zodiac/domain/repositories/zodiac_sevices_repository.dart';
import 'package:zodiac/presentation/screens/services_messages/services/services_state.dart';

@injectable
class ServicesCubit extends Cubit<ServicesState> {
  final ZodiacServicesRepository _zodiacServicesRepository;
  final List<ServiceItem> _services = [];

  ServicesCubit(
    this._zodiacServicesRepository,
  ) : super(const ServicesState()) {
    _init();
  }

  _init() async {
    _getServices();
  }

  Future<void> _getServices() async {
    try {
      final response =
          await _zodiacServicesRepository.getServices(ServiceListRequest(
        count: 1,
        offset: 0,
        status: null,
      ));

      _services.clear();

      if (response.status == true &&
          response.count != 0 &&
          response.result != null &&
          response.result!.isNotEmpty) {
        _services.addAll(response.result!);
        emit(state.copyWith(
          services: List.of(_services),
        ));
      } else {
        // Temporary for testing
        const item = {
          "id": 0,
          "name": 'Karma cleaning',
          "date_create": 1644657729,
          "status": 1,
          "reject_status": 0
        };
        _services.addAll(
            [ServiceItem.fromJson(item), ServiceItem.fromJson(item)].toList());
        //_services.clear();
        emit(state.copyWith(
          services: List.of(_services),
        ));
      }
    } catch (e) {
      logger.d(e);
    }
  }

  Future<void> deleteService(int? serviceId) async {
    /*if (await _deleteCannedMessage(messageId)) {
      _messages.removeWhere((element) => element.id == messageId);
      await filterCannedMessagesByCategory();
    }*/
  }
}
