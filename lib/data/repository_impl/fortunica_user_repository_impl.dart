import 'package:injectable/injectable.dart';

import '../../domain/repositories/fortunica_user_repository.dart';
import '../cache/fortunica_caching_manager.dart';
import '../models/reports_endpoint/reports_statistics.dart';
import '../models/user_info/user_info.dart';
import '../models/user_info/user_profile.dart';
import '../network/api/user_api.dart';
import '../network/requests/push_enable_request.dart';
import '../network/requests/reorder_cover_pictures_request.dart';
import '../network/requests/restore_freshchat_id_request.dart';
import '../network/requests/set_push_notification_token_request.dart';
import '../network/requests/update_profile_image_request.dart';
import '../network/requests/update_profile_request.dart';
import '../network/requests/update_user_status_request.dart';
import '../network/responses/reports_response.dart';

@Injectable(as: FortunicaUserRepository)
class FortunicaUserRepositoryImpl implements FortunicaUserRepository {
  final FortunicaCachingManager _cacheManager;
  final UserApi _api;

  FortunicaUserRepositoryImpl(this._api, this._cacheManager);

  @override
  Future<UserInfo> getUserInfo() async {
    final UserInfo info = await _api.getUserInfo();
    return info;
  }

  @override
  Future<UserInfo> setPushEnabled(PushEnableRequest request) async {
    return await _api.setPushEnabled(request);
  }

  @override
  Future<void> setFreshchatRestoreId(RestoreFreshchatIdRequest request) async {
    return await _api.setFreshchatRestoreId(request);
  }

  @override
  Future<UserInfo> updateUserStatus(UpdateUserStatusRequest request) async {
    return await _api.updateUserStatus(request);
  }

  @override
  Future<UserProfile> updateProfile(UpdateProfileRequest request) async {
    final String? userId = _cacheManager.getUserId();
    return await _api.updateProfile(userId ?? '', request);
  }

  @override
  Future<void> updateProfilePicture(UpdateProfileImageRequest request) async {
    final String? userId = _cacheManager.getUserId();

    List<String> profilePictures =
        await _api.updateProfilePicture(userId ?? '', request);

    _cacheManager.updateUserProfileImage(profilePictures);
  }

  @override
  Future<List<String>> addPictureToGallery(
      UpdateProfileImageRequest request) async {
    final String? userId = _cacheManager.getUserId();

    List<String> coverPictures =
        await _api.addPictureToGallery(userId ?? '', request);

    return coverPictures;
  }

  @override
  Future<List<String>> reorderCoverPictures(
      ReorderCoverPicturesRequest request) async {
    List<String> coverPictures = await _api.reorderCoverPictures(request);
    return coverPictures;
  }

  @override
  Future<List<String>> deleteCoverPicture(int index) async {
    final String? userId = _cacheManager.getUserId();

    List<String> coverPictures = await _api.deleteCoverPicture(
      userId ?? '',
      index,
    );

    return coverPictures;
  }

  @override
  Future<ReportsResponse> getUserReports() async {
    final String? userId = _cacheManager.getUserId();
    return await _api.getUserReports(userId ?? '');
  }

  @override
  Future<ReportsStatistics> getUserReportsByMonth(
    String startDate,
    String endDate,
  ) async {
    final String? userId = _cacheManager.getUserId();
    return await _api.getUserReportsByMonth(userId ?? '', startDate, endDate);
  }

  @override
  Future<UserInfo> sendPushToken(
      SetPushNotificationTokenRequest request) async {
    return _api.setPushNotificationToken(request);
  }
}
