import 'package:zodiac/data/network/requests/authorized_request.dart';
import 'package:zodiac/data/network/requests/services_list_request.dart';
import 'package:zodiac/data/network/responses/default_services_images_response.dart';
import 'package:zodiac/data/network/responses/services_list_response.dart';

abstract class ZodiacServicesRepository {
  Future<DefaultServicesImagesResponse> getDefaultImages(
      AuthorizedRequest request);

  Future<ServiceListResponse> getServices(ServiceListRequest request);
}
