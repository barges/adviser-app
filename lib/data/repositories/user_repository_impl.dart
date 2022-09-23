import 'package:shared_advisor_interface/data/cache/cache_manager.dart';
import 'package:shared_advisor_interface/data/models/user_info/user_info.dart';
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
    await _cacheManager.saveUserInfo(info);
    return info;
  }

  @override
  Future<void> updateProfile(UpdateProfileRequest request) async {
    final String? userId = _cacheManager.getUserInfo()?.id;
    _api.updateProfile(userId ?? '', request);
  }

  @override
  Future<List<String>> updateProfilePicture(
      UpdateProfileImageRequest request) async {
    final String? userId = _cacheManager.getUserInfo()?.id;
    return _api.updateProfilePicture(userId ?? '', request);
  }

  @override
  Future<List<String>> updateCoverPicture(
      UpdateProfileImageRequest request) async {
    final String? userId = _cacheManager.getUserInfo()?.id;
    return _api.updateCoverPicture(userId ?? '', request);
  }
}
