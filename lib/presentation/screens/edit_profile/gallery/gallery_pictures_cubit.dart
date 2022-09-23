import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/presentation/screens/edit_profile/gallery/gallery_pictures_state.dart';

class GalleryPicturesCubit extends Cubit<GalleryPicturesState> {
  late final PageController pageController;

  GalleryPicturesCubit() : super(GalleryPicturesState()) {
    final double initPage = Get.arguments;
    pageController = PageController(initialPage: initPage.toInt());
  }

  @override
  Future<void> close() {
    pageController.dispose();
    return super.close();
  }
}
