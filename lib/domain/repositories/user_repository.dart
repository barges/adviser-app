import 'package:shared_advisor_interface/data/models/reports_endpoint/reports_statistics.dart';
import 'package:shared_advisor_interface/data/models/user_info/user_info.dart';
import 'package:shared_advisor_interface/data/models/user_info/user_profile.dart';
import 'package:shared_advisor_interface/data/network/requests/push_enable_request.dart';
import 'package:shared_advisor_interface/data/network/requests/update_profile_image_request.dart';
import 'package:shared_advisor_interface/data/network/requests/update_profile_request.dart';
import 'package:shared_advisor_interface/data/network/requests/update_user_status_request.dart';
import 'package:shared_advisor_interface/data/network/responses/reports_response.dart';

abstract class UserRepository {
  Future<UserInfo> getUserInfo();

  Future<UserInfo> updateUserStatus(UpdateUserStatusRequest request);

  Future<UserInfo> setPushEnabled(PushEnableRequest request);

  Future<UserProfile> updateProfile(
    UpdateProfileRequest request,
  );

  Future<void> updateProfilePicture(
    UpdateProfileImageRequest request,
  );

  Future<List<String>> addCoverPictureToGallery(
    UpdateProfileImageRequest request,
  );

  Future<List<String>> updateCoverPicture(
    UpdateProfileImageRequest request,
  );

  Future<List<String>> deleteCoverPicture(
    int index,
  );

  Future<ReportsResponse> getUserReports();

  Future<ReportsStatistics> getUserReportsByMonth(
    String startDate,
    String endDate,
  );
}
