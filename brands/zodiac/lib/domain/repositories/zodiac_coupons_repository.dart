import 'package:zodiac/data/network/requests/authorized_request.dart';
import 'package:zodiac/data/network/requests/set_daily_coupons_request.dart';
import 'package:zodiac/data/network/requests/update_enabled_request.dart';
import 'package:zodiac/data/network/responses/base_response.dart';
import 'package:zodiac/data/network/responses/daily_coupons_response.dart';

abstract class ZodiacCouponsRepository {
  Future<DailyCouponsResponse> getDailyCoupons(AuthorizedRequest request);

  Future<BaseResponse> setDailyCoupons(SetDailyCouponsRequest request);

  Future<BaseResponse> updateEnableDailyCoupons(UpdateEnabledRequest request);

  Future<BaseResponse> updateEnableDailyCouponsRenewal(
      UpdateEnabledRequest request);
}
