import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart'
    hide CacheManager;
import 'package:get/get.dart';
import 'package:mime/mime.dart';
import 'package:shared_advisor_interface/data/cache/caching_manager.dart';
import 'package:shared_advisor_interface/data/models/enums/markets_type.dart';
import 'package:shared_advisor_interface/data/models/user_info/localized_properties/localized_properties.dart';
import 'package:shared_advisor_interface/data/models/user_info/localized_properties/property_by_language.dart';
import 'package:shared_advisor_interface/data/models/user_info/user_profile.dart';
import 'package:shared_advisor_interface/data/network/requests/update_profile_image_request.dart';
import 'package:shared_advisor_interface/data/network/requests/update_profile_request.dart';
import 'package:shared_advisor_interface/domain/repositories/user_repository.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/resources/app_routes.dart';

import 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  final MainCubit mainCubit = Get.find<MainCubit>();
  final TextEditingController nicknameController = TextEditingController();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  final UserRepository userRepository = Get.find<UserRepository>();
  final CachingManager cacheManager = Get.find<CachingManager>();
  final DefaultCacheManager defaultCacheManager = DefaultCacheManager();

  late final UserProfile? userProfile;
  late final List<MarketsType> activeLanguages;
  late final List<GlobalKey> activeLanguagesGlobalKeys;
  late final Map<String, dynamic> oldPropertiesMap;
  final Map<MarketsType, List<TextEditingController>> textControllersMap = {};
  final Map<MarketsType, List<String>> errorTextsMap = {};
  late final ScrollController languagesScrollController;
  final PageController picturesPageController = PageController();

  int? initialLanguageIndexIfHasError;

  EditProfileCubit() : super(EditProfileState()) {
    userProfile = cacheManager.getUserProfile();
    activeLanguages = userProfile?.activeLanguages ?? [];
    activeLanguagesGlobalKeys =
        activeLanguages.map((e) => GlobalKey()).toList();
    nicknameController.text = userProfile?.profileName ?? '';

    oldPropertiesMap = userProfile?.localizedProperties?.toJson() ?? {};

    createTextControllersAndErrorsMap();

    languagesScrollController = ScrollController();

    if (initialLanguageIndexIfHasError != null) {
      animateLanguageWithError(initialLanguageIndexIfHasError!);
    }

    emit(
      state.copyWith(
          coverPictures: userProfile?.coverPictures ?? [],
          chosenLanguageIndex: initialLanguageIndexIfHasError ?? 0),
    );

    addListenersToTextControllers();
  }

  @override
  Future<void> close() async {
    for (var entry in textControllersMap.entries) {
      for (var element in entry.value) {
        element.dispose();
      }
    }
    nicknameController.dispose();
    picturesPageController.dispose();
    Get.delete<EditProfileCubit>();
    return super.close();
  }

  void createTextControllersAndErrorsMap() {
    if (oldPropertiesMap.isNotEmpty) {
      for (MarketsType marketType in activeLanguages) {
        final PropertyByLanguage property = oldPropertiesMap[marketType.name];
        final TextEditingController statusTextController =
            TextEditingController();
        final TextEditingController profileTextController =
            TextEditingController();
        textControllersMap[marketType] = [
          statusTextController..text = property.statusMessage?.trim() ?? '',
          profileTextController..text = property.description?.trim() ?? '',
        ];

        final String statusErrorMessage =
            statusTextController.text.trim().isEmpty
                ? S.current.fieldIsRequired
                : '';
        final String profileErrorMessage =
            profileTextController.text.trim().isEmpty
                ? S.current.fieldIsRequired
                : '';

        if (statusErrorMessage.isNotEmpty || profileErrorMessage.isNotEmpty) {
          initialLanguageIndexIfHasError ??=
              activeLanguages.indexOf(marketType);
        }

        errorTextsMap[marketType] = [
          statusErrorMessage,
          profileErrorMessage,
        ];
      }
    }
  }

  void animateLanguageWithError(int index) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final BuildContext? context =
          activeLanguagesGlobalKeys[index].currentContext;
      if (context != null) {
        Scrollable.ensureVisible(context,
            duration: const Duration(milliseconds: 500));
      }
    });
  }

  void addListenersToTextControllers() {
    nicknameController.addListener(() {
      emit(state.copyWith(nicknameErrorText: ''));
    });

    for (var entry in textControllersMap.entries) {
      entry.value.firstOrNull?.addListener(() {
        errorTextsMap[entry.key]?.first = '';
        emit(state.copyWith(updateTextsFlag: !state.updateTextsFlag));
      });
      entry.value.lastOrNull?.addListener(() {
        errorTextsMap[entry.key]?.last = '';
        emit(state.copyWith(updateTextsFlag: !state.updateTextsFlag));
      });
    }
  }

  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }

  Future<void> updateUserInfo() async {
    if (mainCubit.state.internetConnectionIsAvailable) {
      final bool profileUpdated = await updateUserProfileTexts();
      final bool coverPictureUpdated = await updateCoverPicture();
      final bool avatarUpdated = await updateUserAvatar();
      if (profileUpdated || coverPictureUpdated || avatarUpdated) {
        Get.back(result: true);
      }
    }
  }

  Future<bool> updateUserProfileTexts() async {
    bool isOk = false;
    final Map<String, dynamic> newPropertiesMap = {};
    for (MapEntry<MarketsType, List<TextEditingController>> entry
        in textControllersMap.entries) {
      newPropertiesMap[entry.key.name] = PropertyByLanguage(
              statusMessage: entry.value.firstOrNull?.text,
              description: entry.value.lastOrNull?.text)
          .toJson();
    }

    final LocalizedProperties newProperties =
        LocalizedProperties.fromJson(newPropertiesMap);

    if (checkNickName() && checkTextFields()) {
      final UserProfile? actualProfile = cacheManager.getUserProfile();

      if (nicknameController.text != actualProfile?.profileName ||
          actualProfile?.localizedProperties != newProperties) {
        final UpdateProfileRequest request = UpdateProfileRequest(
          localizedProperties: newProperties,
          profileName: nicknameController.text,
        );
        final UserProfile profile = await userRepository.updateProfile(request);
        cacheManager.saveUserProfile(
          profile,
        );
        isOk = true;
      }
    }
    return isOk;
  }

  bool checkNickName() {
    bool isValid = true;
    if (nicknameController.text.length < 3) {
      isValid = false;
      emit(
        state.copyWith(
            nicknameErrorText: S.current.pleaseEnterAtLeast3Characters),
      );
    }
    return isValid;
  }

  bool checkTextFields() {
    bool isValid = true;
    int? firstLanguageWithErrorIndex;
    for (MapEntry<MarketsType, List<TextEditingController>> entry
        in textControllersMap.entries) {
      final List<TextEditingController> controllersByLanguage = entry.value;
      if (controllersByLanguage.firstOrNull?.text.trim().isEmpty == true) {
        errorTextsMap[entry.key]?.first = S.current.fieldIsRequired;
        firstLanguageWithErrorIndex ??= activeLanguages.indexOf(entry.key);
        isValid = false;
      }
      if (controllersByLanguage.lastOrNull?.text.trim().isEmpty == true) {
        errorTextsMap[entry.key]?.last = S.current.fieldIsRequired;
        firstLanguageWithErrorIndex ??= activeLanguages.indexOf(entry.key);
        isValid = false;
      }
    }
    if (firstLanguageWithErrorIndex != null) {
      changeCurrentLanguageIndex(firstLanguageWithErrorIndex);
      animateLanguageWithError(firstLanguageWithErrorIndex);
    }
    emit(state.copyWith(updateTextsFlag: !state.updateTextsFlag));
    return isValid;
  }

  Future<bool> updateCoverPicture() async {
    bool isOk = false;
    final int? pictureIndex = picturesPageController.page?.toInt();
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
      final List<String> coverPictures =
          await userRepository.updateCoverPicture(request);
      emit(
        state.copyWith(
          coverPictures: coverPictures,
        ),
      );
      isOk = true;
    }
    return isOk;
  }

  Future<void> deletePictureFromGallery(int pictureIndex) async {
    if (mainCubit.state.internetConnectionIsAvailable) {
      final List<String> coverPictures =
          await userRepository.deleteCoverPicture(pictureIndex);
      emit(
        state.copyWith(
          coverPictures: coverPictures,
        ),
      );
    }
  }

  Future<bool> updateUserAvatar() async {
    bool isOk = false;
    if (state.avatar != null) {
      final String? mimeType = lookupMimeType(state.avatar?.path ?? '');
      final List<int> imageBytes = await state.avatar!.readAsBytes();
      final String base64Image = base64Encode(imageBytes);
      final UpdateProfileImageRequest request = UpdateProfileImageRequest(
        mime: mimeType,
        image: base64Image,
      );
      await userRepository.updateProfilePicture(request);
      isOk = true;
    }
    return isOk;
  }

  Future<void> addPictureToGallery(File? image) async {
    if (mainCubit.state.internetConnectionIsAvailable && image != null) {
      final String? mimeType = lookupMimeType(image.path);
      final List<int> imageBytes = await image.readAsBytes();
      final String base64Image = base64Encode(imageBytes);
      final UpdateProfileImageRequest request = UpdateProfileImageRequest(
        mime: mimeType,
        image: base64Image,
      );
      List<String> coverPictures =
          await userRepository.addCoverPictureToGallery(request);
      emit(state.copyWith(coverPictures: coverPictures));
    }
  }

  void goToGallery() {
    Get.toNamed(
      AppRoutes.galleryPictures,
      arguments: picturesPageController.page,
    );
  }

  void setAvatar(File avatar) {
    emit(state.copyWith(avatar: avatar));
  }

  void setCoverImages(List<String> images) {
    emit(state.copyWith(coverPictures: images));
  }

  void changeCurrentLanguageIndex(int index) {
    emit(state.copyWith(chosenLanguageIndex: index));
  }
}
