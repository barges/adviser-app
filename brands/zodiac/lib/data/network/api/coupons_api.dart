import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';
import 'package:zodiac/data/network/requests/set_daily_coupons_request.dart';
import 'package:zodiac/data/network/requests/update_enabled_request.dart';
import 'package:zodiac/data/network/responses/base_response.dart';
import 'package:zodiac/data/network/responses/daily_coupons_response.dart';

part 'coupons_api.g.dart';

@RestApi()
@injectable
abstract class CouponsApi {
  @factoryMethod
  factory CouponsApi(Dio dio) = _CouponsApi;

  @POST('/advisor-daily-coupons')
  Future<DailyCouponsResponse> getDailyCoupons(
    @Body() AuthorizedRequest request,
  );

  @POST('/advisor-daily-coupons/add')
  Future<BaseResponse> setDailyCoupons(
    @Body() SetDailyCouponsRequest request,
  );

  @POST('/advisor-daily-coupons/enable')
  Future<BaseResponse> updateEnableDailyCoupons(
    @Body() UpdateEnabledRequest request,
  );

  @POST('/advisor-daily-coupons/renewal/enable')
  Future<BaseResponse> updateEnableDailyCouponsRenewal(
    @Body() UpdateEnabledRequest request,
  );
}
