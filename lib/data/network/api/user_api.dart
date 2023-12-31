import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:shared_advisor_interface/data/models/reports_endpoint/reports_statistics.dart';
import 'package:shared_advisor_interface/data/models/user_info/user_info.dart';
import 'package:shared_advisor_interface/data/models/user_info/user_profile.dart';
import 'package:shared_advisor_interface/data/network/requests/push_enable_request.dart';
import 'package:shared_advisor_interface/data/network/requests/reorder_cover_pictures_request.dart';
import 'package:shared_advisor_interface/data/network/requests/restore_freshchat_id_request.dart';
import 'package:shared_advisor_interface/data/network/requests/set_push_notification_token_request.dart';
import 'package:shared_advisor_interface/data/network/requests/update_profile_image_request.dart';
import 'package:shared_advisor_interface/data/network/requests/update_profile_request.dart';
import 'package:shared_advisor_interface/data/network/requests/update_user_status_request.dart';
import 'package:shared_advisor_interface/data/network/responses/reports_response.dart';

part 'user_api.g.dart';

@RestApi()
abstract class UserApi {
  factory UserApi(Dio dio) = _UserApi;

  @GET('/experts')
  Future<UserInfo> getUserInfo();

  @GET('/v2/users/{id}/reports')
  Future<ReportsResponse> getUserReports(
    @Path('id') String id,
  );

  @GET('/v2/users/{id}/reports')
  Future<ReportsStatistics> getUserReportsByMonth(
    @Path('id') String id,
    @Query('start') String startDate,
    @Query('end') String endDate,
  );

  @POST('/experts/pushToken')
  Future<UserInfo> setPushNotificationToken(
    @Body() SetPushNotificationTokenRequest request,
  );

  @POST('/experts/setPushEnabled')
  Future<UserInfo> setPushEnabled(
    @Body() PushEnableRequest request,
  );

  @PUT('/v2/users/user/freshChat')
  Future<void> setFreshchatRestoreId(
    @Body() RestoreFreshchatIdRequest request,
  );

  @PUT('/v2/users/{id}/profile')
  Future<UserProfile> updateProfile(
    @Path('id') String id,
    @Body() UpdateProfileRequest request,
  );

  @PUT('/experts/status')
  Future<UserInfo> updateUserStatus(
    @Body() UpdateUserStatusRequest request,
  );

  @PUT('/v2/users/{id}/profile/profilePicture')
  Future<List<String>> updateProfilePicture(
    @Path('id') String id,
    @Body() UpdateProfileImageRequest request,
  );

  @POST('/v2/users/{id}/profile/coverPictures')
  Future<List<String>> addPictureToGallery(
    @Path('id') String id,
    @Body() UpdateProfileImageRequest request,
  );

  @PUT('/experts/profile/coverPictures/reorder')
  Future<List<String>> reorderCoverPictures(
    @Body() ReorderCoverPicturesRequest request,
  );

  @DELETE('/v2/users/{id}/profile/coverPictures/{index}')
  Future<List<String>> deleteCoverPicture(
    @Path('id') String id,
    @Path('index') int index,
  );
}
