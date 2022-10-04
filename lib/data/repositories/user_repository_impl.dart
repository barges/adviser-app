import 'package:shared_advisor_interface/data/cache/cache_manager.dart';
import 'package:shared_advisor_interface/data/models/user_info/user_info.dart';
import 'package:shared_advisor_interface/data/models/user_info/user_profile.dart';
import 'package:shared_advisor_interface/data/models/user_info/user_status.dart';
import 'package:shared_advisor_interface/data/network/api/user_api.dart';
import 'package:shared_advisor_interface/data/network/requests/push_enable_request.dart';
import 'package:shared_advisor_interface/data/network/requests/update_profile_image_request.dart';
import 'package:shared_advisor_interface/data/network/requests/update_profile_request.dart';
import 'package:shared_advisor_interface/data/network/requests/update_user_status_request.dart';
import 'package:shared_advisor_interface/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final CacheManager _cacheManager;
  final UserApi _api;

  UserRepositoryImpl(this._api, this._cacheManager);

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
  Future<UserStatus> updateUserStatus(UpdateUserStatusRequest request) async {
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
  Future<List<String>> addCoverPictureToGallery(
      UpdateProfileImageRequest request) async {
    final String? userId = _cacheManager.getUserId();

    List<String> coverPictures =
        await _api.addCoverPictureToGallery(userId ?? '', request);

    _cacheManager.updateUserProfileCoverPictures(coverPictures);

    return coverPictures;
  }

  @override
  Future<List<String>> updateCoverPicture(
      UpdateProfileImageRequest request) async {
    final String? userId = _cacheManager.getUserId();

    List<String> coverPictures =
        await _api.updateCoverPicture(userId ?? '', request);

    _cacheManager.updateUserProfileCoverPictures(coverPictures);

    return coverPictures;
  }

  @override
  Future<List<String>> deleteCoverPicture(int index) async {
    final String? userId = _cacheManager.getUserId();

    List<String> coverPictures = await _api.deleteCoverPicture(
      userId ?? '',
      index.toString(),
    );

    _cacheManager.updateUserProfileCoverPictures(coverPictures);

    return coverPictures;
  }
}
