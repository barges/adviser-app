import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get/get.dart';
import 'package:mime/mime.dart';
import 'package:shared_advisor_interface/data/cache/caching_manager.dart';
import 'package:shared_advisor_interface/data/models/user_info/user_profile.dart';
import 'package:shared_advisor_interface/data/network/requests/update_profile_image_request.dart';
import 'package:shared_advisor_interface/domain/repositories/user_repository.dart';
import 'package:shared_advisor_interface/presentation/resources/app_arguments.dart';
import 'package:shared_advisor_interface/presentation/resources/app_routes.dart';
import 'package:shared_advisor_interface/presentation/services/connectivity_service.dart';

part 'add_gallery_pictures_state.dart';
part 'add_gallery_pictures_cubit.freezed.dart';

class AddGalleryPicturesCubit extends Cubit<AddGalleryPicturesState> {
  final UserRepository _userRepository;
  final ConnectivityService _connectivityService;
  final CachingManager _cacheManager;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  late final ValueChanged<List<String>> onUpdateCoverPictures;
  late final UserProfile? userProfile;
  AddGalleryPicturesCubit(
      this._userRepository, this._connectivityService, this._cacheManager)
      : super(AddGalleryPicturesState()) {
    AddGalleryPicturesScreenArguments arguments = Get.arguments;

    onUpdateCoverPictures = arguments.onUpdateCoverPictures;
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
          await _userRepository.addCoverPictureToGallery(request);

      _updateCoverPictures(coverPictures);

      emit(state.copyWith(coverPictures: coverPictures));
    }
  }

  Future<void> deletePictureFromGallery(int pictureIndex) async {
    if (await _connectivityService.checkConnection()) {
      final List<String> coverPictures =
          await _userRepository.deleteCoverPicture(pictureIndex);

      _updateCoverPictures(coverPictures);

      emit(state.copyWith(coverPictures: coverPictures));
    }
  }

  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }

  void _updateCoverPictures(List<String> coverPictures) {
    _cacheManager.updateUserProfileCoverPictures(coverPictures);
    onUpdateCoverPictures(coverPictures);
  }

  void goToGallery(int pictureIndex) {
    Get.toNamed(
      AppRoutes.galleryPictures,
      arguments: GalleryPicturesScreenArguments(
        pictures: state.coverPictures,
        initPage: pictureIndex.toDouble(),
      ),
    );
  }
}
