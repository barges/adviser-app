import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mime/mime.dart';

import '../../../infrastructure/routing/app_router.dart';
import '../../../data/cache/fortunica_caching_manager.dart';
import '../../../data/models/enums/markets_type.dart';
import '../../../data/models/enums/validation_error_type.dart';
import '../../../data/models/user_info/localized_properties/localized_properties.dart';
import '../../../data/models/user_info/localized_properties/property_by_language.dart';
import '../../../data/models/user_info/user_profile.dart';
import '../../../data/network/requests/reorder_cover_pictures_request.dart';
import '../../../data/network/requests/update_profile_image_request.dart';
import '../../../data/network/requests/update_profile_request.dart';
import '../../../domain/repositories/fortunica_user_repository.dart';
import '../../../fortunica_constants.dart';
import '../../../infrastructure/routing/app_router.gr.dart';
import '../../../main_cubit.dart';
import '../../../services/connectivity_service.dart';
import '../../../utils/utils.dart';
import '../gallery/gallery_pictures_screen.dart';
import 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  final MainCubit mainCubit;
  final FortunicaUserRepository userRepository;
  final FortunicaCachingManager cacheManager;
  final ConnectivityService connectivityService;

  final TextEditingController nicknameController = TextEditingController();
  final FocusNode nicknameFocusNode = FocusNode();

  final GlobalKey profileAvatarKey = GlobalKey();
  final GlobalKey nicknameFieldKey = GlobalKey();

  UserProfile? userProfile;
  late List<MarketsType> activeLanguages;
  late List<GlobalKey> activeLanguagesGlobalKeys;
  late Map<String, dynamic> _oldPropertiesMap;
  late final StreamSubscription userProfileSubscription;

  final ScrollController languagesScrollController = ScrollController();
  final PageController picturesPageController = PageController();

  final Map<MarketsType, List<TextEditingController>> textControllersMap = {};
  final Map<MarketsType, List<FocusNode>> focusNodesMap = {};
  final Map<MarketsType, List<ValueNotifier>> hasFocusNotifiersMap = {};
  final Map<MarketsType, List<ValidationErrorType>> errorTextsMap = {};

  int? initialLanguageIndexIfHasError;

  EditProfileCubit({
    required this.mainCubit,
    required this.userRepository,
    required this.cacheManager,
    required this.connectivityService,
  }) : super(EditProfileState()) {
    userProfile = cacheManager.getUserProfile();
    setUpScreenForUserProfile();

    userProfileSubscription = cacheManager.listenUserProfileStream((value) {
      if (userProfile == null) {
        userProfile = value;
        setUpScreenForUserProfile();
      }
      emit(state.copyWith(coverPictures: value.coverPictures ?? []));
    });
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
    userProfileSubscription.cancel();
    return super.close();
  }

  Future<void> refreshUserProfile() async {
    mainCubit.updateAccount();
  }

  void setUpScreenForUserProfile() {
    activeLanguages = userProfile?.activeLanguages ?? [];
    activeLanguagesGlobalKeys =
        activeLanguages.map((e) => GlobalKey()).toList();
    nicknameController.text = userProfile?.profileName ?? '';

    _oldPropertiesMap = userProfile?.localizedProperties?.toJson() ?? {};

    createTextControllersNodesAndErrorsMap();

    _checkNickName();

    _checkEmptyFields();

    emit(
      state.copyWith(
        coverPictures: userProfile?.coverPictures ?? [],
        chosenLanguageIndex: initialLanguageIndexIfHasError ?? 0,
      ),
    );

    if (userProfile != null) {
      emit(state.copyWith(updateTextsFlag: !state.updateTextsFlag));
    }

    _addListenersToTextControllers();
    _addListenersToFocusNodes();
  }

  void createTextControllersNodesAndErrorsMap() {
    if (_oldPropertiesMap.isNotEmpty) {
      for (MarketsType marketType in activeLanguages) {
        final PropertyByLanguage property = _oldPropertiesMap[marketType.name];
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

        final ValidationErrorType statusErrorMessage =
            statusTextController.text.trim().isEmpty
                ? ValidationErrorType.requiredField
                : statusTextController.text.length > 300
                    ? ValidationErrorType.statusTextMayNotExceed300Characters
                    : ValidationErrorType.empty;
        final ValidationErrorType profileErrorMessage =
            profileTextController.text.trim().isEmpty
                ? ValidationErrorType.requiredField
                : ValidationErrorType.empty;

        if (statusErrorMessage != ValidationErrorType.empty ||
            profileErrorMessage != ValidationErrorType.empty) {
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

  void _addListenersToTextControllers() {
    nicknameController.addListener(() {
      if (_checkNickName(false)) {
        emit(state.copyWith(nicknameErrorType: ValidationErrorType.empty));
      }
    });

    for (var entry in textControllersMap.entries) {
      final statusTextController = entry.value.firstOrNull;
      statusTextController?.addListener(() {
        if (statusTextController.text.length > 300) {
          errorTextsMap[entry.key]?.first =
              ValidationErrorType.statusTextMayNotExceed300Characters;
          emit(state.copyWith(updateTextsFlag: !state.updateTextsFlag));
        } else if (statusTextController.text.isEmpty) {
          errorTextsMap[entry.key]?.first = ValidationErrorType.requiredField;
          emit(state.copyWith(updateTextsFlag: !state.updateTextsFlag));
        } else {
          errorTextsMap[entry.key]?.first = ValidationErrorType.empty;
          emit(state.copyWith(updateTextsFlag: !state.updateTextsFlag));
        }
      });
      entry.value.lastOrNull?.addListener(() {
        errorTextsMap[entry.key]?.last = ValidationErrorType.empty;
        emit(state.copyWith(updateTextsFlag: !state.updateTextsFlag));
      });
    }
  }

  void _addListenersToFocusNodes() {
    nicknameFocusNode.addListener(() {
      emit(state.copyWith(nicknameHasFocus: nicknameFocusNode.hasFocus));
    });

    for (var entry in focusNodesMap.entries) {
      for (int i = 0; i < entry.value.length; i++) {
        entry.value[i].addListener(() {
          hasFocusNotifiersMap[entry.key]?[i].value = entry.value[i].hasFocus;
        });
      }
    }
  }

  void goToGallery(BuildContext context) {
    context.push(
      route: FortunicaGalleryPictures(
        galleryPicturesScreenArguments: GalleryPicturesScreenArguments(
          pictures: state.coverPictures,
          editProfilePageController: picturesPageController,
          initPage: picturesPageController.page ?? 0.0,
        ),
      ),
    );
  }

  void goToAddGalleryPictures(BuildContext context) {
    context.push(
      route: const FortunicaAddGalleryPictures(),
    );
  }

  Future<void> updateUserInfo(BuildContext context) async {
    if (await connectivityService.checkConnection()) {
      if (checkTextFields() & _checkNickName() & checkUserAvatar()) {
        final bool profileUpdated = await updateUserProfileTexts();
        final bool coverPictureUpdated = await updateCoverPicture();
        final bool avatarUpdated = await updateUserAvatar();
        if (profileUpdated || coverPictureUpdated || avatarUpdated) {
          context.pop(true);
        } else {
          context.pop();
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
    return isOk;
  }

  bool _checkNickName([bool animate = true]) {
    bool isValid = true;
    if (nicknameController.text.length < FortunicaConstants.minNickNameLength) {
      isValid = false;
      if (animate) {
        Utils.animateToWidget(nicknameFieldKey);
      }
      if (checkUserAvatar()) {
        nicknameFocusNode.requestFocus();
      }
      Future.delayed(Duration(milliseconds: animate ? 500 : 0)).then((value) {
        emit(
          state.copyWith(
              nicknameErrorType: nicknameController.text.isEmpty
                  ? ValidationErrorType.requiredField
                  : ValidationErrorType.pleaseEnterAtLeast3Characters),
        );
      });
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
        errorTextsMap[entry.key]?.first = ValidationErrorType.requiredField;
        firstLanguageWithErrorIndex ??= activeLanguages.indexOf(entry.key);
        firstLanguageWithErrorFocusNode ??= focusNodesMap[entry.key]?.first;
        isValid = false;
      } else if (controllersByLanguage.firstOrNull != null &&
          controllersByLanguage.firstOrNull!.text.length > 300) {
        errorTextsMap[entry.key]?.first =
            ValidationErrorType.statusTextMayNotExceed300Characters;
        firstLanguageWithErrorIndex ??= activeLanguages.indexOf(entry.key);
        firstLanguageWithErrorFocusNode ??= focusNodesMap[entry.key]?.first;
        isValid = false;
      }

      if (controllersByLanguage.lastOrNull?.text.trim().isEmpty == true) {
        errorTextsMap[entry.key]?.last = ValidationErrorType.requiredField;
        firstLanguageWithErrorIndex ??= activeLanguages.indexOf(entry.key);
        firstLanguageWithErrorFocusNode ??= focusNodesMap[entry.key]?.last;
        isValid = false;
      }
    }
    if (firstLanguageWithErrorIndex != null) {
      changeCurrentLanguageIndex(firstLanguageWithErrorIndex);
      Utils.animateToWidget(
          activeLanguagesGlobalKeys[firstLanguageWithErrorIndex]);
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
        final List<int> indexes = [pictureIndex];
        state.coverPictures.forEachIndexed((index, element) {
          if (index != pictureIndex) {
            indexes.add(index);
          }
        });
        List<String> coverPictures = await userRepository
            .reorderCoverPictures(ReorderCoverPicturesRequest(
          indexes: indexes.join(','),
        ));
        cacheManager.updateUserProfileCoverPictures(coverPictures);
        isOk = true;
      }
    }
    return isOk;
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

  void setAvatar(File avatar) {
    emit(state.copyWith(avatar: avatar));
  }

  void changeCurrentLanguageIndex(int index) {
    emit(state.copyWith(chosenLanguageIndex: index));
  }

  void _checkEmptyFields() {
    if (userProfile?.profilePictures?.isNotEmpty != true) {
      Utils.animateToWidget(profileAvatarKey);
    } else if (nicknameController.text.isEmpty) {
      Utils.animateToWidget(nicknameFieldKey);
    } else if (initialLanguageIndexIfHasError != null) {
      Utils.animateToWidget(
          activeLanguagesGlobalKeys[initialLanguageIndexIfHasError!]);
    }
  }

  bool checkUserAvatar() {
    bool isValid = true;
    if (userProfile?.profilePictures?.isNotEmpty != true &&
        state.avatar == null) {
      Utils.animateToWidget(profileAvatarKey);
      isValid = false;
    }
    return isValid;
  }
}
