import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';
import 'package:zodiac/data/network/requests/services_list_request.dart';
import 'package:zodiac/data/network/responses/default_services_images_response.dart';
import 'package:zodiac/data/network/responses/services_list_response.dart';

part 'services_api.g.dart';

@RestApi()
@injectable
abstract class ServicesApi {
  @factoryMethod
  factory ServicesApi(Dio dio) = _ServicesApi;

  @POST('/service/get-default-images')
  Future<DefaultServicesImagesResponse> getDefaultImages(
      @Body() AuthorizedRequest request);

  @POST('/service/list')
  Future<ServiceListResponse> getServices(@Body() ServiceListRequest request);
}
