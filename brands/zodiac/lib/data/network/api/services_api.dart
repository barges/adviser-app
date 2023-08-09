import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:zodiac/data/network/requests/add_service_request.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';
import 'package:zodiac/data/network/requests/services_list_request.dart';
import 'package:zodiac/data/network/responses/add_service_response.dart';
import 'package:zodiac/data/network/responses/default_services_images_response.dart';
import 'package:zodiac/data/network/responses/services_list_response.dart';

part 'services_api.g.dart';

@RestApi()
@injectable
abstract class ServicesApi {
  @factoryMethod
  factory ServicesApi(Dio dio) = _ServicesApi;

  @POST('/advisor/services/image-samples')
  Future<DefaultServicesImagesResponse> getDefaultImages(
      @Body() AuthorizedRequest request);

  @POST('/advisor/services')
  Future<ServiceListResponse> getServices(@Body() ServiceListRequest request);

  @POST('/advisor/services/add')
  Future<AddServiceResponse> addService(@Body() AddServiceRequest request);
}
