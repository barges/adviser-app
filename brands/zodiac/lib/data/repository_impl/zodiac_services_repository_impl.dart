import 'package:injectable/injectable.dart';
import 'package:zodiac/data/network/api/services_api.dart';
import 'package:zodiac/data/network/requests/add_service_request.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';
import 'package:zodiac/data/network/requests/get_service_info_request.dart';
import 'package:zodiac/data/network/requests/services_list_request.dart';
import 'package:zodiac/data/network/responses/add_service_response.dart';
import 'package:zodiac/data/network/responses/default_services_images_response.dart';
import 'package:zodiac/data/network/responses/get_service_info_response.dart';
import 'package:zodiac/data/network/responses/services_list_response.dart';
import 'package:zodiac/domain/repositories/zodiac_sevices_repository.dart';

@Injectable(as: ZodiacServicesRepository)
class ZodiacServicesRepositoryImpl implements ZodiacServicesRepository {
  final ServicesApi _api;

  ZodiacServicesRepositoryImpl(this._api);

  @override
  Future<DefaultServicesImagesResponse> getDefaultImages(
      AuthorizedRequest request) async {
    return await _api.getDefaultImages(request);
  }

  @override
  Future<AddServiceResponse> addService(AddServiceRequest request) async {
    return await _api.addService(request);
  }

  @override
  Future<ServiceListResponse> getServices(ServiceListRequest request) async {
    return await _api.getServices(request);
  }

  @override
  Future<GetServiceInfoResponse> getServiceInfo(
      GetServiceInfoRequest request) async {
    return await _api.getServiceInfo(request);
  }
}
