import 'package:zodiac/data/network/requests/add_service_request.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';
import 'package:zodiac/data/network/responses/add_service_response.dart';
import 'package:zodiac/data/network/responses/default_services_images_response.dart';

abstract class ZodiacServicesRepository {
  Future<DefaultServicesImagesResponse> getDefaultImages(
      AuthorizedRequest request);

  Future<AddServiceResponse> addService(AddServiceRequest request);
}
