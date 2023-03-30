import 'package:injectable/injectable.dart';
import 'package:zodiac/data/network/api/user_api.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';
import 'package:zodiac/data/network/requests/list_request.dart';
import 'package:zodiac/data/network/requests/notifications_request.dart';
import 'package:zodiac/data/network/requests/reviews_request.dart';
import 'package:zodiac/data/network/requests/send_push_token_request.dart';
import 'package:zodiac/data/network/requests/update_locale_request.dart';
import 'package:zodiac/data/network/requests/update_user_status_request.dart';
import 'package:zodiac/data/network/responses/base_response.dart';
import 'package:zodiac/data/network/requests/update_random_call_enabled_request.dart';
import 'package:zodiac/data/network/responses/expert_details_response.dart';
import 'package:zodiac/data/network/requests/expert_details_request.dart';
import 'package:zodiac/data/network/responses/notifications_response.dart';
import 'package:zodiac/data/network/responses/payments_list_response.dart';
import 'package:zodiac/data/network/responses/price_settings_response.dart';
import 'package:zodiac/data/network/requests/price_settings_request.dart';
import 'package:zodiac/data/network/responses/reviews_response.dart';
import 'package:zodiac/data/network/responses/my_details_response.dart';
import 'package:zodiac/domain/repositories/zodiac_user_repository.dart';

@Injectable(as: ZodiacUserRepository)
class ZodiacUserRepositoryImpl implements ZodiacUserRepository {
  final UserApi _userApi;

  const ZodiacUserRepositoryImpl(this._userApi);

  @override
  Future<MyDetailsResponse> getMyDetails(AuthorizedRequest request) async {
    return await _userApi.getMyDetails(request);
  }

  @override
  Future<PriceSettingsResponse> getPriceSettings(
      AuthorizedRequest request) async {
    return await _userApi.getPriceSettings(request);
  }

  @override
  Future<PriceSettingsResponse> setPriceSettings(
      PriceSettingsRequest request) async {
    return await _userApi.setPriceSettings(request);
  }

  @override
  Future<ExpertDetailsResponse> getDetailedUserInfo(
      ExpertDetailsRequest request) async {
    return await _userApi.getExpertProfile(request);
  }

  @override
  Future<BaseResponse> updateRandomCallsEnabled(
      UpdateRandomCallEnabledRequest request) async {
    return await _userApi.updateRandomCallsEnabled(request);
  }

  @override
  Future<BaseResponse> updateUserStatus(UpdateUserStatusRequest request) async {
    return await _userApi.updateUserStatus(request);
  }

  @override
  Future<NotificationsResponse> getNotificationsList(
      NotificationsRequest request) async {
    return await _userApi.getNotificationsList(request);
  }

  @override
  Future<ReviewsResponse?> getReviews(ReviewsRequest request) async {
    return await _userApi.getReviews(request);
  }

  @override
  Future<PaymentsListResponse> getPaymentsList(ListRequest request) async {
    return await _userApi.getPaymentsList(request);
  }

  @override
  Future<BaseResponse> sendPushToken(SendPushTokenRequest request) async {
    return _userApi.sendPushToken(request);
  }

  @override
  Future<BaseResponse> updateLocale(UpdateLocaleRequest request) async {
    return await _userApi.updateLocale(request);
  }
}
