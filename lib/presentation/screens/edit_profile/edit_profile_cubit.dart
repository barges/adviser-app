import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart'
    hide CacheManager;
import 'package:get/get.dart';
import 'package:mime/mime.dart';
import 'package:shared_advisor_interface/data/cache/cache_manager.dart';
import 'package:shared_advisor_interface/data/models/localized_properties/localized_properties.dart';
import 'package:shared_advisor_interface/data/models/localized_properties/property_by_language.dart';
import 'package:shared_advisor_interface/data/models/user_info/user_profile.dart';
import 'package:shared_advisor_interface/data/network/requests/update_profile_image_request.dart';
import 'package:shared_advisor_interface/data/network/requests/update_profile_request.dart';
import 'package:shared_advisor_interface/domain/repositories/user_repository.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';

import 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  final TextEditingController nicknameController = TextEditingController();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  final UserRepository userRepository = Get.find<UserRepository>();
  final CacheManager cacheManager = Get.find<CacheManager>();
  final DefaultCacheManager defaultCacheManager = DefaultCacheManager();

  late final UserProfile? userProfile;
  late final List<String> activeLanguages;
  late final Map<String, dynamic> oldPropertiesMap;
  final Map<String, List<TextEditingController>> textControllersMap = {};
  final PageController pageController = PageController();

  EditProfileCubit() : super(EditProfileState()) {
    userProfile = cacheManager.getUserProfile();
    activeLanguages = userProfile?.activeLanguages ?? [];
    nicknameController.text = userProfile?.profileName ?? '';

    oldPropertiesMap = userProfile?.localizedProperties?.toJson() ?? {};

    if (oldPropertiesMap.isNotEmpty) {
      for (String languageCode in activeLanguages) {
        final PropertyByLanguage property = oldPropertiesMap[languageCode];
        final TextEditingController statusTextController =
            TextEditingController();
        final TextEditingController profileTextController =
            TextEditingController();
        statusTextController.text = property.statusMessage ?? '';
        profileTextController.text = property.description ?? '';
        textControllersMap[languageCode] = [
          statusTextController,
          profileTextController
        ];
      }
    }
    emit(state.copyWith(coverPictures: userProfile?.coverPictures ?? []));

    nicknameController.addListener(() {
      emit(state.copyWith(nicknameErrorText: ''));
    });
  }

  @override
  Future<void> close() async {
    for (var entry in textControllersMap.entries) {
      for (var element in entry.value) {
        element.dispose();
      }
    }
    nicknameController.dispose();
    pageController.dispose();
    return super.close();
  }

  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }

  Future<void> updateUserInfo(BuildContext context) async {
    await updateUserProfileTexts(context);
    await updateCoverPicture();
    await updateUserAvatar();
  }

  Future<void> updateUserProfileTexts(BuildContext context) async {
    final Map<String, dynamic> newPropertiesMap = {};
    for (MapEntry<String, List<TextEditingController>> entry
        in textControllersMap.entries) {
      newPropertiesMap[entry.key] = PropertyByLanguage(
              statusMessage: entry.value.firstOrNull?.text,
              description: entry.value.lastOrNull?.text)
          .toJson();
    }

    final LocalizedProperties newProperties =
        LocalizedProperties.fromJson(newPropertiesMap);

    if (nicknameIsValid()) {
      final UserProfile? actualProfile = cacheManager.getUserProfile();

      if (nicknameController.text != actualProfile?.profileName ||
          actualProfile?.localizedProperties != newProperties) {
        final UpdateProfileRequest request = UpdateProfileRequest(
          localizedProperties: newProperties,
          profileName: nicknameController.text,
        );
        await run(userRepository.updateProfile(request));
      }
    } else {
      emit(
        state.copyWith(
            nicknameErrorText: S.of(context).pleaseEnterAtLeast3Characters),
      );
    }
  }

  Future<void> updateCoverPicture() async {
    final int? pictureIndex = pageController.page?.toInt();
    if (pictureIndex != null && pictureIndex > 0) {
      final String url = state.coverPictures[pictureIndex];
      final File file = await defaultCacheManager.getSingleFile(url);
      final String? mimeType = lookupMimeType(file.path);
      final List<int> imageBytes = await file.readAsBytes();
      final String base64Image = base64Encode(imageBytes);
      final UpdateProfileImageRequest request = UpdateProfileImageRequest(
        mime: mimeType,
        image: base64Image,
      );
      try {
        final List<String> coverPictures = await run(
          userRepository.updateCoverPicture(
            request,
          ),
        );
        emit(
          state.copyWith(
            coverPictures: coverPictures,
          ),
        );
      } catch (e) {
        ///TODO: Handle the error
        rethrow;
      }
    }
  }

  Future<void> deletePictureFromGallery(int pictureIndex) async {
    try {
      final List<String> coverPictures = await run(
        userRepository.deleteCoverPicture(
          pictureIndex,
        ),
      );
      emit(
        state.copyWith(
          coverPictures: coverPictures,
        ),
      );
    } catch (e) {
      ///TODO: Handle the error
      rethrow;
    }
  }

  Future<void> updateUserAvatar() async {
    if (state.avatar != null) {
      final String? mimeType = lookupMimeType(state.avatar?.path ?? '');
      final List<int> imageBytes = await state.avatar!.readAsBytes();
      final String base64Image = base64Encode(imageBytes);
      final UpdateProfileImageRequest request = UpdateProfileImageRequest(
        mime: mimeType,
        image: base64Image,
      );
      try {
        await run(userRepository.updateProfilePicture(request));
      } catch (e) {
        ///TODO: Handle the error
        rethrow;
      }
    }
  }

  Future<void> addPictureToGallery(File? image) async {
    if (image != null) {
      final String? mimeType = lookupMimeType(image.path);
      final List<int> imageBytes = await image.readAsBytes();
      final String base64Image = base64Encode(imageBytes);
      final UpdateProfileImageRequest request = UpdateProfileImageRequest(
        mime: mimeType,
        image: base64Image,
      );
      try {
        List<String> coverPictures =
            await run(userRepository.addCoverPictureToGallery(request));
        emit(state.copyWith(coverPictures: coverPictures));
      } catch (e) {
        ///TODO: Handle the error
        rethrow;
      }
    }
  }

  void setIsWideAppbar(bool isWide) {
    emit(state.copyWith(isWideAppBar: isWide));
  }

  void setAvatar(File avatar) {
    emit(state.copyWith(avatar: avatar));
  }

  void setCoverImages(List<String> images) {
    emit(state.copyWith(coverPictures: images));
  }

  void updateCurrentLanguageIndex(int index) {
    emit(state.copyWith(chosenLanguageIndex: index));
  }

  bool nicknameIsValid() => nicknameController.text.length >= 3;
}
