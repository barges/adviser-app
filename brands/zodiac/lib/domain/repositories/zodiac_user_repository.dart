import 'dart:io';

import 'package:zodiac/data/network/requests/add_remove_locale_request.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';
import 'package:zodiac/data/network/requests/change_advisor_specializations_request.dart';
import 'package:zodiac/data/network/requests/change_main_specialization_request.dart';
import 'package:zodiac/data/network/requests/list_request.dart';
import 'package:zodiac/data/network/requests/locale_descriptions_request.dart';
import 'package:zodiac/data/network/requests/price_settings_request.dart';
import 'package:zodiac/data/network/requests/send_push_token_request.dart';
import 'package:zodiac/data/network/requests/update_locale_request.dart';
import 'package:zodiac/data/network/requests/update_random_call_enabled_request.dart';
import 'package:zodiac/data/network/requests/update_user_status_request.dart';
import 'package:zodiac/data/network/responses/base_response.dart';
import 'package:zodiac/data/network/responses/expert_details_response.dart';
import 'package:zodiac/data/network/responses/locale_descriptions_response.dart';
import 'package:zodiac/data/network/responses/locales_response.dart';
import 'package:zodiac/data/network/responses/main_specialization_response.dart';
import 'package:zodiac/data/network/responses/notifications_response.dart';
import 'package:zodiac/data/network/responses/payments_list_response.dart';
import 'package:zodiac/data/network/responses/price_settings_response.dart';
import 'package:zodiac/data/network/responses/reviews_response.dart';
import 'package:zodiac/data/network/responses/my_details_response.dart';
import 'package:zodiac/data/network/responses/specializations_response.dart';

abstract class ZodiacUserRepository {
  Future<LocalesResponse> getPreferredLocales(AuthorizedRequest request);

  Future<MyDetailsResponse> getMyDetails(AuthorizedRequest request);

  Future<PriceSettingsResponse> getPriceSettings(AuthorizedRequest request);

  Future<PriceSettingsResponse> setPriceSettings(PriceSettingsRequest request);

  Future<ExpertDetailsResponse> getDetailedUserInfo(AuthorizedRequest request);

  Future<BaseResponse> updateRandomCallsEnabled(
      UpdateRandomCallEnabledRequest request);

  Future<BaseResponse> updateUserStatus(UpdateUserStatusRequest request);

  Future<NotificationsResponse> getNotificationsList(ListRequest request);

  Future<ReviewsResponse?> getReviews(ListRequest request);

  Future<PaymentsListResponse> getPaymentsList(ListRequest request);

  Future<BaseResponse> sendPushToken(
    SendPushTokenRequest request,
  );

  Future<BaseResponse> updateLocale(UpdateLocaleRequest request);

  Future<SpecializationsResponse> getSpecializations(
    AuthorizedRequest request,
  );

  Future<SpecializationsResponse> changeAdvisorSpecializations(
    ChangeAdvisorSpecializationsRequest request,
  );

  Future<MainSpecializationResponse> getMainSpeciality(
    AuthorizedRequest request,
  );

  Future<BaseResponse> changeMainSpecialization(
    ChangeMainSpecializationRequest request,
  );

  Future<LocaleDescriptionsResponse> getLocaleDescriptions(
    LocaleDescriptionsRequest request,
  );

  Future<BaseResponse> addLocaleAdvisor(
    AddRemoveLocaleRequest request,
  );

  Future<BaseResponse> removeLocaleAdvisor(
    AddRemoveLocaleRequest request,
  );

  Future<BaseResponse> uploadAvatar({
    required AuthorizedRequest request,
    required int brandId,
    required File avatar,
  });
}
