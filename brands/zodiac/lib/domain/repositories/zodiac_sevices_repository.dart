import 'package:zodiac/data/network/requests/add_service_request.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';
import 'package:zodiac/data/network/requests/edit_service_request.dart';
import 'package:zodiac/data/network/requests/get_service_info_request.dart';
import 'package:zodiac/data/network/requests/services_list_request.dart';
import 'package:zodiac/data/network/responses/add_service_response.dart';
import 'package:zodiac/data/network/responses/base_response.dart';
import 'package:zodiac/data/network/responses/default_services_images_response.dart';
import 'package:zodiac/data/network/responses/get_service_info_response.dart';
import 'package:zodiac/data/network/responses/services_list_response.dart';

abstract class ZodiacServicesRepository {
  Future<DefaultServicesImagesResponse> getDefaultImages(
      AuthorizedRequest request);

  Future<AddServiceResponse> addService(AddServiceRequest request);

  Future<ServiceListResponse> getServices(ServiceListRequest request);

  Future<GetServiceInfoResponse> getServiceInfo(GetServiceInfoRequest request);

  Future<BaseResponse> editService(EditServiceRequest request);
}
