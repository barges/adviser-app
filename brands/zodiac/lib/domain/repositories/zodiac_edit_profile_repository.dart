import 'package:zodiac/data/network/requests/authorized_request.dart';
import 'package:zodiac/data/network/responses/brand_locales_response.dart';

abstract class ZodiacEditProfileRepository {
  Future<BrandLocalesResponse> getBrandLocales(AuthorizedRequest request);
}
