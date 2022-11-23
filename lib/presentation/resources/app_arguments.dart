import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/configuration.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs_types.dart';

class HomeScreenArguments {
  final TabsTypes initTab;

  HomeScreenArguments({
    required this.initTab,
  });
}

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

class AddNoteScreenArguments {
  final String customerID;
  final String? oldNote;
  final String? updatedAt;
  VoidCallback noteChanged;

  AddNoteScreenArguments(
      {required this.customerID,
      this.oldNote,
      this.updatedAt,
      required this.noteChanged});
}

class ChatScreenArguments {
  final String? questionId;
  final String? clientId;

  ChatScreenArguments({
    this.questionId,
    this.clientId,
  });
}
