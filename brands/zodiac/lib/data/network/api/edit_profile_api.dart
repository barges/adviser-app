import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';
import 'package:zodiac/data/network/requests/list_request.dart';
import 'package:zodiac/data/network/responses/brand_locales_response.dart';
import 'package:zodiac/data/network/responses/specializations_response.dart';

part 'edit_profile_api.g.dart';

@RestApi()
@injectable
abstract class EditProfileApi {
  @factoryMethod
  factory EditProfileApi(Dio dio) = _EditProfileApi;

  @POST('/advisor/brand-locales/list')
  Future<BrandLocalesResponse> getBrandLocales(
    @Body() AuthorizedRequest request,
  );

  @POST('/category/list')
  Future<SpecializationsResponse> getCategories(
    @Body() ListRequest request,
  );
}
