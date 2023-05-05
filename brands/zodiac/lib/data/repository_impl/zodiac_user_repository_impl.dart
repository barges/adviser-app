import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:zodiac/data/network/api/user_api.dart';
import 'package:zodiac/data/network/requests/add_remove_locale_request.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';
import 'package:zodiac/data/network/requests/change_advisor_specializations_request.dart';
import 'package:zodiac/data/network/requests/change_main_specialization_request.dart';
import 'package:zodiac/data/network/requests/list_request.dart';
import 'package:zodiac/data/network/requests/locale_descriptions_request.dart';
import 'package:zodiac/data/network/requests/notification_details_request.dart';
import 'package:zodiac/data/network/requests/notifications_request.dart';
import 'package:zodiac/data/network/requests/phone_number_request.dart';
import 'package:zodiac/data/network/requests/phone_number_verify_request.dart';
import 'package:zodiac/data/network/requests/send_push_token_request.dart';
import 'package:zodiac/data/network/requests/settings_request.dart';
import 'package:zodiac/data/network/requests/update_locale_request.dart';
import 'package:zodiac/data/network/requests/update_user_status_request.dart';
import 'package:zodiac/data/network/responses/balance_response.dart';
import 'package:zodiac/data/network/responses/base_response.dart';
import 'package:zodiac/data/network/requests/update_random_call_enabled_request.dart';
import 'package:zodiac/data/network/responses/expert_details_response.dart';
import 'package:zodiac/data/network/responses/locale_descriptions_response.dart';
import 'package:zodiac/data/network/responses/locales_response.dart';
import 'package:zodiac/data/network/responses/main_specialization_response.dart';
import 'package:zodiac/data/network/responses/notification_details_response.dart';
import 'package:zodiac/data/network/responses/notifications_response.dart';
import 'package:zodiac/data/network/responses/payments_list_response.dart';
import 'package:zodiac/data/network/responses/phone_number_response.dart';
import 'package:zodiac/data/network/responses/phone_number_verify_response.dart';
import 'package:zodiac/data/network/responses/price_settings_response.dart';
import 'package:zodiac/data/network/requests/price_settings_request.dart';
import 'package:zodiac/data/network/responses/reviews_response.dart';
import 'package:zodiac/data/network/responses/my_details_response.dart';
import 'package:zodiac/data/network/responses/settings_response.dart';
import 'package:zodiac/data/network/responses/specializations_response.dart';
import 'package:zodiac/domain/repositories/zodiac_user_repository.dart';

@Injectable(as: ZodiacUserRepository)
class ZodiacUserRepositoryImpl implements ZodiacUserRepository {
  final UserApi _userApi;

  const ZodiacUserRepositoryImpl(this._userApi);

  @override
  Future<LocalesResponse> getAllLocales(AuthorizedRequest request) async {
    return await _userApi.getPreferredLocales(request);
  }

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
      AuthorizedRequest request) async {
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
  Future<ReviewsResponse?> getReviews(ListRequest request) async {
    return await _userApi.getReviews(request);
  }

  @override
  Future<PaymentsListResponse> getPaymentsList(ListRequest request) async {
    return await _userApi.getPaymentsList(request);
  }

  @override
  Future<BalanceResponse> getBalance(AuthorizedRequest request) async {
    return await _userApi.getBalance(request: request);
  }

  @override
  Future<BaseResponse> sendPushToken(SendPushTokenRequest request) async {
    return _userApi.sendPushToken(request);
  }

  @override
  Future<BaseResponse> updateLocale(UpdateLocaleRequest request) async {
    return await _userApi.updateLocale(request);
  }

  @override
  Future<SpecializationsResponse> getSpecializations(
    AuthorizedRequest request,
  ) async {
    return await _userApi.getSpecialities(request);
  }

  @override
  Future<SpecializationsResponse> changeAdvisorSpecializations(
    ChangeAdvisorSpecializationsRequest request,
  ) async {
    return await _userApi.changeAdvisorSpecialities(request);
  }

  @override
  Future<MainSpecializationResponse> getMainSpeciality(
    AuthorizedRequest request,
  ) async {
    return await _userApi.getMainSpeciality(request);
  }

  @override
  Future<BaseResponse> changeMainSpecialization(
    ChangeMainSpecializationRequest request,
  ) async {
    return await _userApi.changeMainSpeciality(request);
  }

  @override
  Future<LocaleDescriptionsResponse> getLocaleDescriptions(
    LocaleDescriptionsRequest request,
  ) async {
    return await _userApi.getLocaleDescriptions(request);
  }

  @override
  Future<BaseResponse> addLocaleAdvisor(
    AddRemoveLocaleRequest request,
  ) async {
    return await _userApi.addLocaleAdvisor(request);
  }

  @override
  Future<BaseResponse> updateLocaleDescriptionsAdvisor(
    AddRemoveLocaleRequest request,
  ) async {
    return await _userApi.updateLocaleDescriptionsAdvisor(request);
  }

  @override
  Future<BaseResponse> removeLocaleAdvisor(
    AddRemoveLocaleRequest request,
  ) async {
    return await _userApi.removeLocaleAdvisor(request);
  }

  @override
  Future<BaseResponse> uploadAvatar({
    required AuthorizedRequest request,
    required int brandId,
    required File avatar,
  }) async {
    return await _userApi.uploadAvatar(
      secret: request.secret,
      package: request.package,
      version: request.version,
      auth: request.auth,
      brandId: brandId,
      avatar: avatar,
    );
  }

  @override
  Future<NotificationDetailsResponse> getNotificationDetails(
      NotificationDetailsRequest request) async {
    return await _userApi.getNotificationDetails(request);
  }

  @override
  Future<BaseResponse> notifyPushClick(
      NotificationDetailsRequest request) async {
    return await _userApi.notifyPushClick(request);
  }

  @override
  Future<SettingsResponse> getSettings(SettingsRequest request) async {
    return await _userApi.getSettings(request);
  }

  @override
  Future<PhoneNumberResponse> editPhoneNumber(
      PhoneNumberRequest request) async {
    return await _userApi.editPhoneNumber(request);
  }

  @override
  Future<PhoneNumberVerifyResponse> verifyPhoneNumber(
      PhoneNumberVerifyRequest request) async {
    return await _userApi.verifyPhoneNumber(request);
  }

  @override
  Future<BaseResponse> resendPhoneVerification(
      PhoneNumberVerifyRequest request) async {
    return await _userApi.resendPhoneVerification(request);
  }
}
