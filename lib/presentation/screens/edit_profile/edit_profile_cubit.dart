import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/data/cache/cache_manager.dart';
import 'package:shared_advisor_interface/data/models/localized_properties/property_by_language.dart';
import 'package:shared_advisor_interface/data/models/user_info/user_info.dart';
import 'package:shared_advisor_interface/domain/repositories/user_repository.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/main.dart';

import 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  final TextEditingController nicknameController = TextEditingController();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  final UserRepository userRepository = Get.find<UserRepository>();
  final CacheManager cacheManager = Get.find<CacheManager>();

  late final UserInfo? userInfo;
  late final List<String> activeLanguages;
  final Map<String, List<TextEditingController>> textControllers = {};
  final PageController pageController = PageController();

  EditProfileCubit() : super(EditProfileState()) {
    userInfo = cacheManager.getUserInfo();
    activeLanguages = userInfo?.profile?.activeLanguages ?? [];
    nicknameController.text = userInfo?.profile?.profileName ?? '';

    logger.d(userInfo?.id);

    final Map<String, dynamic>? propertiesMap =
        userInfo?.profile?.localizedProperties?.toJson();

    if (propertiesMap != null) {
      for (String languageCode in activeLanguages) {
        final PropertyByLanguage property = propertiesMap[languageCode];
        final TextEditingController statusTextController =
            TextEditingController();
        final TextEditingController profileTextController =
            TextEditingController();
        statusTextController.text = property.statusMessage ?? '';
        profileTextController.text = property.description ?? '';
        textControllers[languageCode] = [
          statusTextController,
          profileTextController
        ];
      }
    }
    emit(state.copyWith(coverImages: userInfo?.profile?.coverPictures ?? []));

    nicknameController.addListener(() {
      emit(state.copyWith(nicknameErrorText: ''));
    });
  }

  @override
  Future<void> close() async {
    for (var entry in textControllers.entries) {
      for (var element in entry.value) {
        element.dispose();
      }
    }
    pageController.dispose();
    return super.close();
  }

  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }

  Future<void> updateUser(BuildContext context) async {
    if (nicknameIsValid()) {
    } else {
      emit(
        state.copyWith(
            nicknameErrorText: S.of(context).pleaseEnterAtLeast3Characters),
      );
    }
  }

  void setIsWideAppbar(bool isWide) {
    emit(state.copyWith(isWideAppBar: isWide));
  }

  void setAvatar(File avatar) {
    emit(state.copyWith(avatar: avatar));
  }

  void setBackgroundImage(File image) {
    emit(state.copyWith(backgroundImage: image));
  }

  void setCoverImages(List<String> images) {
    emit(state.copyWith(coverImages: images));
  }

  void updateCurrentLanguageIndex(int index) {
    emit(state.copyWith(chosenLanguageIndex: index));
  }

  bool nicknameIsValid() => nicknameController.text.length >= 3;
}
