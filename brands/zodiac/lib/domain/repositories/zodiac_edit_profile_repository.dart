import 'package:zodiac/data/network/requests/authorized_request.dart';
import 'package:zodiac/data/network/requests/list_request.dart';
import 'package:zodiac/data/network/requests/save_brand_locales_request.dart';
import 'package:zodiac/data/network/responses/base_response.dart';
import 'package:zodiac/data/network/responses/brand_locales_response.dart';
import 'package:zodiac/data/network/responses/specializations_response.dart';

abstract class ZodiacEditProfileRepository {
  Future<BrandLocalesResponse> getBrandLocales(AuthorizedRequest request);

  Future<SpecializationsResponse> getCategories(ListRequest request);

  Future<SpecializationsResponse> getMethods(AuthorizedRequest request);

  Future<BaseResponse> saveBrandLocales(SaveBrandLocalesRequest request);
}
