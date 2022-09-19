import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  final ImagePicker _picker = ImagePicker();

  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController statusTextController = TextEditingController();
  final TextEditingController profileTextController = TextEditingController();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  EditProfileCubit() : super(EditProfileState());

  Future<void> pickProfileImageFromGallery() async {
    XFile image =
        await _picker.pickImage(source: ImageSource.gallery) ?? XFile('');
    emit(state.copyWith(imagePath: image.path));
  }

  Future<void> addNewImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      List<XFile> imagesFromGallery = [];
      imagesFromGallery.addAll(state.imagesFromGallery);
      imagesFromGallery.add(image);
      emit(state.copyWith(imagesFromGallery: imagesFromGallery));
    }
  }

  void removeGalleryImage(int index) {
    List<XFile> imagesFromGallery = [];
    imagesFromGallery.addAll(state.imagesFromGallery);
    imagesFromGallery.removeAt(index);
    emit(state.copyWith(imagesFromGallery: imagesFromGallery));
  }

  void updateCurrentLanguageIndex(int index) {
    emit(state.copyWith(chosenLanguageIndex: index));
  }
}
