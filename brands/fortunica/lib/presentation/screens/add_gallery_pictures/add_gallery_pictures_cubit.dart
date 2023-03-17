import 'dart:convert';
import 'dart:io';

import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.gr.dart';
import 'package:shared_advisor_interface/services/connectivity_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortunica/data/cache/fortunica_caching_manager.dart';
import 'package:fortunica/data/models/user_info/user_profile.dart';
import 'package:fortunica/data/network/requests/update_profile_image_request.dart';
import 'package:fortunica/domain/repositories/fortunica_user_repository.dart';
import 'package:fortunica/presentation/screens/gallery/gallery_pictures_screen.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mime/mime.dart';

part 'add_gallery_pictures_state.dart';
part 'add_gallery_pictures_cubit.freezed.dart';

class AddGalleryPicturesCubit extends Cubit<AddGalleryPicturesState> {
  final FortunicaUserRepository _userRepository;
  final ConnectivityService _connectivityService;
  final FortunicaCachingManager _cacheManager;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  late final UserProfile? userProfile;
  AddGalleryPicturesCubit(
      this._userRepository, this._connectivityService, this._cacheManager)
      : super(AddGalleryPicturesState()) {
    userProfile = _cacheManager.getUserProfile();

    emit(
      state.copyWith(
        coverPictures: userProfile?.coverPictures ?? [],
      ),
    );
  }

  Future<void> addPictureToGallery(File? image) async {
    if (await _connectivityService.checkConnection() && image != null) {
      final String? mimeType = lookupMimeType(image.path);
      final List<int> imageBytes = await image.readAsBytes();
      final String base64Image = base64Encode(imageBytes);
      final UpdateProfileImageRequest request = UpdateProfileImageRequest(
        mime: mimeType,
        image: base64Image,
      );
      List<String> coverPictures =
          await _userRepository.addPictureToGallery(request);

      _cacheManager.updateUserProfileCoverPictures(coverPictures);

      emit(state.copyWith(coverPictures: coverPictures));
    }
  }

  Future<void> deletePictureFromGallery(int pictureIndex) async {
    if (await _connectivityService.checkConnection()) {
      final List<String> coverPictures =
          await _userRepository.deleteCoverPicture(pictureIndex);

      _cacheManager.updateUserProfileCoverPictures(coverPictures);

      emit(state.copyWith(coverPictures: coverPictures));
    }
  }
}
