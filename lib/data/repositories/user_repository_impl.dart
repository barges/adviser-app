import 'package:shared_advisor_interface/data/cache/cache_manager.dart';
import 'package:shared_advisor_interface/data/models/user_info/user_info.dart';
import 'package:shared_advisor_interface/data/models/user_info/user_profile.dart';
import 'package:shared_advisor_interface/data/network/api/user_api.dart';
import 'package:shared_advisor_interface/data/network/requests/update_profile_image_request.dart';
import 'package:shared_advisor_interface/data/network/requests/update_profile_request.dart';
import 'package:shared_advisor_interface/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final CacheManager _cacheManager;
  final UserApi _api;

  UserRepositoryImpl(this._api, this._cacheManager);

  @override
  Future<UserInfo> getUserInfo() async {
    final UserInfo info = await _api.getUserInfo();
    await _cacheManager.saveUserProfile(info.profile);
    await _cacheManager.saveUserId(info.id);
    return info;
  }

  @override
  Future<void> updateProfile(UpdateProfileRequest request) async {
    final String? userId = _cacheManager.getUserId();
    try {
      UserProfile userProfile = await _api.updateProfile(userId ?? '', request);
      _cacheManager.saveUserProfile(userProfile);
    } catch (e) {
      ///TODO: Handle the error
      rethrow;
    }
  }

  @override
  Future<void> updateProfilePicture(UpdateProfileImageRequest request) async {
    final String? userId = _cacheManager.getUserId();

    List<String> profilePictures =
        await _api.updateProfilePicture(userId ?? '', request);

    _cacheManager.updateUserProfileProfileImage(profilePictures);
  }

  @override
  Future<List<String>> addCoverPictureToGallery(
      UpdateProfileImageRequest request) async {
    final String? userId = _cacheManager.getUserId();
    return _api.addCoverPictureToGallery(userId ?? '', request);
  }
}
