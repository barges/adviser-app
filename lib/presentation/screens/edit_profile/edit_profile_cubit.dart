import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';

import 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController statusTextController = TextEditingController();
  final TextEditingController profileTextController = TextEditingController();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  final ScrollController scrollController = ScrollController();

  EditProfileCubit() : super(EditProfileState()) {
    scrollController.addListener(() {
    });
    nicknameController.addListener(() {
      emit(state.copyWith(nicknameErrorText: ''));
    });
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

  void updateCurrentLanguageIndex(int index) {
    emit(state.copyWith(chosenLanguageIndex: index));
  }

  bool nicknameIsValid() => nicknameController.text.length >= 3;
}
