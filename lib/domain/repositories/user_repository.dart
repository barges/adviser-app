import 'package:shared_advisor_interface/data/models/user_info/user_info.dart';
import 'package:shared_advisor_interface/data/network/requests/update_profile_image_request.dart';
import 'package:shared_advisor_interface/data/network/requests/update_profile_request.dart';

abstract class UserRepository {
  Future<UserInfo> getUserInfo();

  Future<void> updateProfile(
    UpdateProfileRequest request,
  );

  Future<void> updateProfilePicture(
    UpdateProfileImageRequest request,
  );

  Future<List<String>> updateCoverPicture(
    UpdateProfileImageRequest request,
  );
}
