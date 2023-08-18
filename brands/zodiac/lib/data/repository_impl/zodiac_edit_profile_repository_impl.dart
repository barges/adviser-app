import 'package:injectable/injectable.dart';
import 'package:zodiac/data/network/api/edit_profile_api.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';
import 'package:zodiac/data/network/responses/brand_locales_response.dart';
import 'package:zodiac/domain/repositories/zodiac_edit_profile_repository.dart';

@Injectable(as: ZodiacEditProfileRepository)
class ZodiacEditProfileRepositoryImpl implements ZodiacEditProfileRepository {
  final EditProfileApi _editProfileApi;

  const ZodiacEditProfileRepositoryImpl(this._editProfileApi);

  @override
  Future<BrandLocalesResponse> getBrandLocales(
      AuthorizedRequest request) async {
    return await _editProfileApi.getBrandLocales(request);
  }
}
