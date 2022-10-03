import 'package:shared_advisor_interface/data/models/user_info/user_info.dart';
import 'package:shared_advisor_interface/data/network/requests/push_enable_request.dart';
import 'package:shared_advisor_interface/data/network/requests/update_profile_image_request.dart';
import 'package:shared_advisor_interface/data/network/requests/update_profile_request.dart';

abstract class UserRepository {
  Future<UserInfo> getUserInfo();

  Future<UserInfo> setPushEnabled(PushEnableRequest request);

  Future<void> updateProfile(
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
}
