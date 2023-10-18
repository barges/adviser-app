import 'package:zodiac/data/network/requests/authorized_request.dart';
import 'package:zodiac/data/network/requests/list_request.dart';
import 'package:zodiac/data/network/requests/notification_details_request.dart';
import 'package:zodiac/data/network/requests/notifications_request.dart';
import 'package:zodiac/data/network/requests/phone_number_request.dart';
import 'package:zodiac/data/network/requests/phone_number_verify_request.dart';
import 'package:zodiac/data/network/requests/price_settings_request.dart';
import 'package:zodiac/data/network/requests/profile_details_request.dart';
import 'package:zodiac/data/network/requests/send_push_token_request.dart';
import 'package:zodiac/data/network/requests/settings_request.dart';
import 'package:zodiac/data/network/requests/update_locale_request.dart';
import 'package:zodiac/data/network/requests/update_random_call_enabled_request.dart';
import 'package:zodiac/data/network/requests/update_user_status_request.dart';
import 'package:zodiac/data/network/responses/balance_response.dart';
import 'package:zodiac/data/network/responses/base_response.dart';
import 'package:zodiac/data/network/responses/expert_details_response.dart';
import 'package:zodiac/data/network/responses/notification_details_response.dart';
import 'package:zodiac/data/network/responses/locales_response.dart';
import 'package:zodiac/data/network/responses/notifications_response.dart';
import 'package:zodiac/data/network/responses/payments_list_response.dart';
import 'package:zodiac/data/network/responses/phone_number_response.dart';
import 'package:zodiac/data/network/responses/phone_number_verify_response.dart';
import 'package:zodiac/data/network/responses/price_settings_response.dart';
import 'package:zodiac/data/network/responses/profile_details_response.dart';
import 'package:zodiac/data/network/responses/reviews_response.dart';
import 'package:zodiac/data/network/responses/my_details_response.dart';
import 'package:zodiac/data/network/responses/settings_response.dart';
import 'package:zodiac/data/network/responses/specializations_response.dart';

abstract class ZodiacUserRepository {
  Future<LocalesResponse> getAllLocales(AuthorizedRequest request);

  Future<MyDetailsResponse> getMyDetails(AuthorizedRequest request);

  Future<PriceSettingsResponse> getPriceSettings(AuthorizedRequest request);

  Future<PriceSettingsResponse> setPriceSettings(PriceSettingsRequest request);

  Future<ExpertDetailsResponse> getDetailedUserInfo(AuthorizedRequest request);

  Future<BaseResponse> updateRandomCallsEnabled(
      UpdateRandomCallEnabledRequest request);

  Future<BaseResponse> updateUserStatus(UpdateUserStatusRequest request);

  Future<NotificationsResponse> getNotificationsList(
      NotificationsRequest request);

  Future<ReviewsResponse?> getReviews(ListRequest request);

  Future<PaymentsListResponse> getPaymentsList(ListRequest request);

  Future<BalanceResponse> getBalance(AuthorizedRequest request);

  Future<BaseResponse> sendPushToken(
    SendPushTokenRequest request,
  );

  Future<BaseResponse> updateLocale(UpdateLocaleRequest request);

  Future<SpecializationsResponse> getSpecializations(
    AuthorizedRequest request,
  );

  Future<NotificationDetailsResponse> getNotificationDetails(
      NotificationDetailsRequest request);

  Future<BaseResponse> notifyPushClick(NotificationDetailsRequest request);

  Future<SettingsResponse> getSettings(SettingsRequest request);

  Future<PhoneNumberResponse> editPhoneNumber(PhoneNumberRequest request);

  Future<PhoneNumberVerifyResponse> verifyPhoneNumber(
      PhoneNumberVerifyRequest request);

  Future<BaseResponse> resendPhoneVerification(
      PhoneNumberVerifyRequest request);

  Future<ProfileDetailsResponse> getProfileDetails(
      ProfileDetailsRequest request);
}
