import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
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
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/resources/app_arguments.dart';
import 'package:shared_advisor_interface/presentation/resources/app_routes.dart';

import 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  final MainCubit mainCubit = getIt.get<MainCubit>();
  final TextEditingController nicknameController = TextEditingController();
  final FocusNode nicknameFocusNode = FocusNode();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  final GlobalKey profileAvatarKey = GlobalKey();
  final GlobalKey nicknameFieldKey = GlobalKey();

  final UserRepository _userRepository = getIt.get<UserRepository>();
  final CachingManager _cacheManager = getIt.get<CachingManager>();
  final DefaultCacheManager _defaultCacheManager = DefaultCacheManager();

  late final UserProfile? userProfile;
  late final List<MarketsType> activeLanguages;
  late final List<GlobalKey> activeLanguagesGlobalKeys;
  late final Map<String, dynamic> oldPropertiesMap;

  final ScrollController languagesScrollController = ScrollController();
  final PageController picturesPageController = PageController();

  final Map<MarketsType, List<TextEditingController>> textControllersMap = {};
  final Map<MarketsType, List<FocusNode>> focusNodesMap = {};
  final Map<MarketsType, List<ValueNotifier>> hasFocusNotifiersMap = {};
  final Map<MarketsType, List<String>> errorTextsMap = {};

  int? initialLanguageIndexIfHasError;

  EditProfileCubit() : super(EditProfileState()) {
    userProfile = _cacheManager.getUserProfile();
    activeLanguages = userProfile?.activeLanguages ?? [];
    activeLanguagesGlobalKeys =
        activeLanguages.map((e) => GlobalKey()).toList();
    nicknameController.text = userProfile?.profileName ?? '';

    oldPropertiesMap = userProfile?.localizedProperties?.toJson() ?? {};

    createTextControllersNodesAndErrorsMap();

    checkEmptyFields();

    emit(
      state.copyWith(
          coverPictures: userProfile?.coverPictures ?? [],
          chosenLanguageIndex: initialLanguageIndexIfHasError ?? 0,
          nicknameErrorText:
              nicknameController.text.isEmpty ? S.current.fieldIsRequired : ''),
    );

    addListenersToTextControllers();
    addListenersToFocusNodes();
  }

  @override
  Future<void> close() async {
    for (var entry in textControllersMap.entries) {
      for (var element in entry.value) {
        element.dispose();
      }
    }
    for (var entry in focusNodesMap.entries) {
      for (var element in entry.value) {
        element.dispose();
      }
    }
    for (var entry in hasFocusNotifiersMap.entries) {
      for (var element in entry.value) {
        element.dispose();
      }
    }
    nicknameController.dispose();
    nicknameFocusNode.dispose();
    picturesPageController.dispose();
    return super.close();
  }

  void goToGallery() {
    Get.toNamed(
      AppRoutes.galleryPictures,
      arguments: GalleryPicturesScreenArguments(
        pictures: state.coverPictures,
        editProfilePageController: picturesPageController,
        initPage: picturesPageController.page ?? 0.0,
      ),
    );
  }

  void createTextControllersNodesAndErrorsMap() {
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
        focusNodesMap[marketType] = [
          FocusNode(),
          FocusNode(),
        ];
        hasFocusNotifiersMap[marketType] = [
          ValueNotifier(false),
          ValueNotifier(false),
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

  void animateWithError(GlobalKey key) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final BuildContext? context = key.currentContext;
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

  void addListenersToFocusNodes() {
    nicknameFocusNode.addListener(() {
      emit(state.copyWith(nicknameHasFocus: nicknameFocusNode.hasFocus));
    });

    for (var entry in focusNodesMap.entries) {
      entry.value.firstOrNull?.addListener(() {
        hasFocusNotifiersMap[entry.key]?.first.value =
            entry.value.first.hasFocus;
      });
      entry.value.lastOrNull?.addListener(() {
        hasFocusNotifiersMap[entry.key]?.last.value = entry.value.last.hasFocus;
      });
    }
  }

  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }

  Future<void> updateUserInfo() async {
    if (mainCubit.state.internetConnectionIsAvailable) {
      if (checkTextFields() & checkNickName() & checkUserAvatar()) {
        final bool profileUpdated = await updateUserProfileTexts();
        final bool coverPictureUpdated = await updateCoverPicture();
        final bool avatarUpdated = await updateUserAvatar();
        if (profileUpdated || coverPictureUpdated || avatarUpdated) {
          Get.back(result: true);
        } else {
          Get.back();
        }
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

    final UserProfile? actualProfile = _cacheManager.getUserProfile();

    if (nicknameController.text != actualProfile?.profileName ||
        actualProfile?.localizedProperties != newProperties) {
      final UpdateProfileRequest request = UpdateProfileRequest(
        localizedProperties: newProperties,
        profileName: nicknameController.text,
      );
      final UserProfile profile = await _userRepository.updateProfile(request);
      _cacheManager.saveUserProfile(
        profile,
      );
      isOk = true;
    }
    return isOk;
  }

  bool checkNickName() {
    bool isValid = true;
    if (nicknameController.text.length < 3) {
      isValid = false;
      animateWithError(nicknameFieldKey);
      if (checkUserAvatar()) {
        nicknameFocusNode.requestFocus();
      }

      emit(
        state.copyWith(
            nicknameErrorText: nicknameController.text.isEmpty
                ? S.current.fieldIsRequired
                : S.current.pleaseEnterAtLeast3Characters),
      );
    }
    return isValid;
  }

  bool checkTextFields() {
    bool isValid = true;
    int? firstLanguageWithErrorIndex;
    FocusNode? firstLanguageWithErrorFocusNode;
    for (MapEntry<MarketsType, List<TextEditingController>> entry
        in textControllersMap.entries) {
      final List<TextEditingController> controllersByLanguage = entry.value;
      if (controllersByLanguage.firstOrNull?.text.trim().isEmpty == true) {
        errorTextsMap[entry.key]?.first = S.current.fieldIsRequired;
        firstLanguageWithErrorIndex ??= activeLanguages.indexOf(entry.key);
        firstLanguageWithErrorFocusNode ??= focusNodesMap[entry.key]?.first;
        isValid = false;
      }
      if (controllersByLanguage.lastOrNull?.text.trim().isEmpty == true) {
        errorTextsMap[entry.key]?.last = S.current.fieldIsRequired;
        firstLanguageWithErrorIndex ??= activeLanguages.indexOf(entry.key);
        firstLanguageWithErrorFocusNode ??= focusNodesMap[entry.key]?.last;
        isValid = false;
      }
    }
    if (firstLanguageWithErrorIndex != null) {
      changeCurrentLanguageIndex(firstLanguageWithErrorIndex);
      animateWithError(activeLanguagesGlobalKeys[firstLanguageWithErrorIndex]);
      if (checkUserAvatar()) {
        firstLanguageWithErrorFocusNode?.requestFocus();
      }
    }
    emit(state.copyWith(updateTextsFlag: !state.updateTextsFlag));
    return isValid;
  }

  Future<bool> updateCoverPicture() async {
    bool isOk = false;
    if (state.coverPictures.isNotEmpty) {
      final int? pictureIndex = picturesPageController.page?.toInt();
      if (pictureIndex != null && pictureIndex > 0) {
        final String url = state.coverPictures[pictureIndex];
        final File file = await _defaultCacheManager.getSingleFile(url);
        final String? mimeType = lookupMimeType(file.path);
        final List<int> imageBytes = await file.readAsBytes();
        final String base64Image = base64Encode(imageBytes);
        final UpdateProfileImageRequest request = UpdateProfileImageRequest(
          mime: mimeType,
          image: base64Image,
        );
        final List<String> coverPictures =
            await _userRepository.updateCoverPicture(request);
        _cacheManager.updateUserProfileCoverPictures(coverPictures);
        emit(
          state.copyWith(
            coverPictures: coverPictures,
          ),
        );
        isOk = true;
      }
    }
    return isOk;
  }

  Future<void> deletePictureFromGallery(int pictureIndex) async {
    if (mainCubit.state.internetConnectionIsAvailable) {
      final List<String> coverPictures =
          await _userRepository.deleteCoverPicture(pictureIndex);
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
      await _userRepository.updateProfilePicture(request);
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
          await _userRepository.addCoverPictureToGallery(request);
      emit(state.copyWith(coverPictures: coverPictures));
    }
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

  void checkEmptyFields() {
    if (userProfile?.profilePictures?.isNotEmpty != true) {
      animateWithError(profileAvatarKey);
    } else if (nicknameController.text.isEmpty) {
      animateWithError(nicknameFieldKey);
    } else if (initialLanguageIndexIfHasError != null) {
      animateWithError(
          activeLanguagesGlobalKeys[initialLanguageIndexIfHasError!]);
    }
  }

  bool checkUserAvatar() {
    bool isValid = true;
    if (userProfile?.profilePictures?.isNotEmpty != true &&
        state.avatar == null) {
      animateWithError(profileAvatarKey);
      isValid = false;
    }
    return isValid;
  }
}
