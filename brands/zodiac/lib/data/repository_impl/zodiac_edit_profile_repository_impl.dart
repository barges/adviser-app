import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:zodiac/data/network/api/edit_profile_api.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';
import 'package:zodiac/data/network/requests/list_request.dart';
import 'package:zodiac/data/network/requests/save_brand_locales_request.dart';
import 'package:zodiac/data/network/responses/base_response.dart';
import 'package:zodiac/data/network/responses/brand_locales_response.dart';
import 'package:zodiac/data/network/responses/specializations_response.dart';
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

  @override
  Future<SpecializationsResponse> getCategories(ListRequest request) async {
    return await _editProfileApi.getCategories(request);
  }

  @override
  Future<SpecializationsResponse> getMethods(AuthorizedRequest request) async {
    return await _editProfileApi.getMethods(request);
  }

  @override
  Future<BaseResponse> saveBrandLocales(SaveBrandLocalesRequest request) async {
    return await _editProfileApi.saveBrandLocales(request);
  }

  @override
  Future<BaseResponse> uploadAvatar(
      {required AuthorizedRequest request,
      required int brandId,
      required File avatar}) async {
    return await _editProfileApi.uploadAvatar(
      secret: request.secret,
      package: request.package,
      version: request.version,
      auth: request.auth,
      brandId: brandId,
      avatar: avatar,
    );
  }
}
