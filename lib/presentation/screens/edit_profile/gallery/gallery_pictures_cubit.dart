import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/presentation/resources/app_arguments.dart';
import 'package:shared_advisor_interface/presentation/screens/edit_profile/gallery/gallery_pictures_state.dart';

class GalleryPicturesCubit extends Cubit<GalleryPicturesState> {
  late final PageController pageController;
  late final PageController editProfilePageController;
  late final List<String> coverPictures;

  GalleryPicturesCubit() : super(GalleryPicturesState()) {
    final GalleryPicturesScreenArguments galleryPicturesScreenArguments =
        Get.arguments;
    editProfilePageController =
        galleryPicturesScreenArguments.editProfilePageController;
    coverPictures = galleryPicturesScreenArguments.pictures;
    pageController = PageController(
        initialPage: galleryPicturesScreenArguments.initPage.toInt());
  }

  @override
  Future<void> close() {
    pageController.dispose();
    return super.close();
  }
}
