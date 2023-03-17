

import 'package:fortunica/data/models/reports_endpoint/reports_statistics.dart';
import 'package:fortunica/data/models/user_info/user_info.dart';
import 'package:fortunica/data/models/user_info/user_profile.dart';
import 'package:fortunica/data/network/requests/push_enable_request.dart';
import 'package:fortunica/data/network/requests/reorder_cover_pictures_request.dart';
import 'package:fortunica/data/network/requests/restore_freshchat_id_request.dart';
import 'package:fortunica/data/network/requests/set_push_notification_token_request.dart';
import 'package:fortunica/data/network/requests/update_profile_image_request.dart';
import 'package:fortunica/data/network/requests/update_profile_request.dart';
import 'package:fortunica/data/network/requests/update_user_status_request.dart';
import 'package:fortunica/data/network/responses/reports_response.dart';

abstract class FortunicaUserRepository {
  Future<UserInfo> getUserInfo();

  Future<UserInfo> updateUserStatus(UpdateUserStatusRequest request);

  Future<UserInfo> setPushEnabled(PushEnableRequest request);

  Future<void> setFreshchatRestoreId(RestoreFreshchatIdRequest request);

  Future<UserProfile> updateProfile(
    UpdateProfileRequest request,
  );

  Future<void> updateProfilePicture(
    UpdateProfileImageRequest request,
  );

  Future<List<String>> addPictureToGallery(
    UpdateProfileImageRequest request,
  );

  Future<List<String>> reorderCoverPictures(
      ReorderCoverPicturesRequest request);

  Future<List<String>> deleteCoverPicture(
    int index,
  );

  Future<ReportsResponse> getUserReports();

  Future<ReportsStatistics> getUserReportsByMonth(
    String startDate,
    String endDate,
  );

  Future<UserInfo> sendPushToken(SetPushNotificationTokenRequest request);
}
