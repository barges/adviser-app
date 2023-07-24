import 'package:injectable/injectable.dart';
import 'package:zodiac/data/network/api/coupons_api.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';
import 'package:zodiac/data/network/requests/set_daily_coupons_request.dart';
import 'package:zodiac/data/network/requests/update_enabled_request.dart';
import 'package:zodiac/data/network/responses/base_response.dart';
import 'package:zodiac/data/network/responses/daily_coupons_response.dart';
import 'package:zodiac/domain/repositories/zodiac_coupons_repository.dart';

@Injectable(as: ZodiacCouponsRepository)
class ZodiacCouponsRepositoryImpl implements ZodiacCouponsRepository {
  final CouponsApi _couponsApi;

  const ZodiacCouponsRepositoryImpl(this._couponsApi);

  @override
  Future<DailyCouponsResponse> getDailyCoupons(
      AuthorizedRequest request) async {
    return await _couponsApi.getDailyCoupons(request);
  }

  @override
  Future<BaseResponse> setDailyCoupons(SetDailyCouponsRequest request) async {
    return await _couponsApi.setDailyCoupons(request);
  }

  @override
  Future<BaseResponse> updateEnableDailyCoupons(
      UpdateEnabledRequest request) async {
    return await _couponsApi.updateEnableDailyCoupons(request);
  }

  @override
  Future<BaseResponse> updateEnableDailyCouponsRenewal(
      UpdateEnabledRequest request) async {
    return await _couponsApi.updateEnableDailyCouponsRenewal(request);
  }
}
