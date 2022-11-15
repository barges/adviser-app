import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/configuration.dart';

class GalleryPicturesScreenArguments {
  final List<String> pictures;
  final PageController editProfilePageController;
  final double initPage;

  GalleryPicturesScreenArguments({
    required this.pictures,
    required this.editProfilePageController,
    required this.initPage,
  });
}

class ForgotPasswordScreenArguments {
  final Brand brand;
  final String? token;

  ForgotPasswordScreenArguments({
    required this.brand,
    this.token,
  });
}
