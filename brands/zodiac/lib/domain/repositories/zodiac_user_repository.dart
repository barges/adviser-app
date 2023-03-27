import 'package:zodiac/data/network/requests/authorized_request.dart';
import 'package:zodiac/data/network/requests/expert_details_request.dart';
import 'package:zodiac/data/network/requests/list_request.dart';
import 'package:zodiac/data/network/requests/notifications_request.dart';
import 'package:zodiac/data/network/requests/price_settings_request.dart';
import 'package:zodiac/data/network/requests/reviews_request.dart';
import 'package:zodiac/data/network/requests/update_locale_request.dart';
import 'package:zodiac/data/network/requests/update_random_call_enabled_request.dart';
import 'package:zodiac/data/network/requests/update_user_status_request.dart';
import 'package:zodiac/data/network/responses/base_response.dart';
import 'package:zodiac/data/network/responses/expert_details_response.dart';
import 'package:zodiac/data/network/responses/notifications_response.dart';
import 'package:zodiac/data/network/responses/payments_list_response.dart';
import 'package:zodiac/data/network/responses/price_settings_response.dart';
import 'package:zodiac/data/network/responses/reviews_response.dart';
import 'package:zodiac/data/network/responses/user_info_response.dart';

abstract class ZodiacUserRepository {
  Future<UserInfoResponse> getUserInfo(AuthorizedRequest request);

  Future<PriceSettingsResponse> getPriceSettings(AuthorizedRequest request);

  Future<PriceSettingsResponse> setPriceSettings(PriceSettingsRequest request);

  Future<ExpertDetailsResponse> getDetailedUserInfo(
      ExpertDetailsRequest request);

  Future<BaseResponse> updateRandomCallsEnabled(
      UpdateRandomCallEnabledRequest request);

  Future<BaseResponse> updateUserStatus(UpdateUserStatusRequest request);

  Future<NotificationsResponse> getNotificationsList(
      NotificationsRequest request);

  Future<ReviewsResponse?> getReviews(ReviewsRequest request);

  Future<PaymentsListResponse> getPaymentsList(ListRequest request);

  Future<BaseResponse> updateLocale(UpdateLocaleRequest request);
}
