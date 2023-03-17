import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortunica/presentation/screens/gallery/gallery_pictures_state.dart';

class GalleryPicturesCubit extends Cubit<GalleryPicturesState> {
  final double? initPage;

  late final PageController pageController;

  GalleryPicturesCubit({this.initPage}) : super(GalleryPicturesState()) {
    pageController = PageController(initialPage: initPage?.toInt() ?? 0);
  }

  @override
  Future<void> close() {
    pageController.dispose();
    return super.close();
  }
}
