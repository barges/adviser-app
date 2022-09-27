import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:shared_advisor_interface/data/models/user_info/user_info.dart';
import 'package:shared_advisor_interface/data/models/user_info/user_profile.dart';
import 'package:shared_advisor_interface/data/network/requests/update_profile_image_request.dart';
import 'package:shared_advisor_interface/data/network/requests/update_profile_request.dart';

part 'user_api.g.dart';

@RestApi()
abstract class UserApi {
  factory UserApi(Dio dio) = _UserApi;

  @GET('/experts')
  Future<UserInfo> getUserInfo();

  @PUT('/v2/users/{id}/profile')
  Future<UserProfile> updateProfile(
    @Path('id') String id,
    @Body() UpdateProfileRequest request,
  );

  @PUT('/v2/users/{id}/profile/profilePicture')
  Future<List<String>> updateProfilePicture(
    @Path('id') String id,
    @Body() UpdateProfileImageRequest request,
  );

  @POST('/v2/users/{id}/profile/coverPictures')
  Future<List<String>> addCoverPictureToGallery(
    @Path('id') String id,
    @Body() UpdateProfileImageRequest request,
  );

  @PUT('/v2/users/{id}/profile/coverPictures/0')
  Future<List<String>> updateCoverPicture(
    @Path('id') String id,
    @Body() UpdateProfileImageRequest request,
  );

  @DELETE('/v2/users/{id}/profile/coverPictures/{index}')
  Future<List<String>> deleteCoverPicture(
    @Path('id') String id,
    @Path('index') String index,
  );
}
