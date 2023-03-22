import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';
import 'package:zodiac/data/network/requests/expert_details_request.dart';
import 'package:zodiac/data/network/requests/notifications_request.dart';
import 'package:zodiac/data/network/requests/price_settings_request.dart';
import 'package:zodiac/data/network/requests/reviews_request.dart';
import 'package:zodiac/data/network/requests/update_random_call_enabled_request.dart';
import 'package:zodiac/data/network/requests/update_user_status_request.dart';
import 'package:zodiac/data/network/responses/base_response.dart';
import 'package:zodiac/data/network/responses/expert_details_response.dart';
import 'package:zodiac/data/network/responses/notifications_response.dart';
import 'package:zodiac/data/network/responses/price_settings_response.dart';
import 'package:zodiac/data/network/responses/reviews_response.dart';
import 'package:zodiac/data/network/responses/user_info_response.dart';

part 'user_api.g.dart';

@RestApi()
@injectable
abstract class UserApi {
  @factoryMethod
  factory UserApi(Dio dio) = _UserApi;

  @POST('/my-details')
  Future<UserInfoResponse> getUserInfo(
    @Body() AuthorizedRequest request,
  );

  @POST('/expert/reviews')
  Future<ReviewsResponse?> getReviews(
    @Body() ReviewsRequest request,
  );

  @POST('/price-settings')
  Future<PriceSettingsResponse> getPriceSettings(
    @Body() AuthorizedRequest request,
  );

  @POST('/price-settings')
  Future<PriceSettingsResponse> setPriceSettings(
    @Body() PriceSettingsRequest request,
  );

  @POST('/expert/profile')
  Future<ExpertDetailsResponse> getExpertProfile(
    @Body() ExpertDetailsRequest request,
  );

  @POST('/save-random-call-option')
  Future<BaseResponse> updateRandomCallsEnabled(
    @Body() UpdateRandomCallEnabledRequest request,
  );

  @POST('/force-status')
  Future<BaseResponse> updateUserStatus(
    @Body() UpdateUserStatusRequest request,
  );

  @POST('/notifications')
  Future<NotificationsResponse> getNotificationsList(
    @Body() NotificationsRequest request,
  );
}