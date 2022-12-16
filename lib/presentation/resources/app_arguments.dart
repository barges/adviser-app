import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/configuration.dart';
import 'package:shared_advisor_interface/data/models/chats/chat_item.dart';
import 'package:shared_advisor_interface/data/models/enums/zodiac_sign.dart';
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
  final String? resetToken;

  ForgotPasswordScreenArguments({
    required this.brand,
    this.resetToken,
  });
}

class CustomerProfileScreenArguments {
  final String customerID;
  final String clientName;
  final ZodiacSign? zodiacSign;

  CustomerProfileScreenArguments({
    required this.customerID,
    required this.clientName,
    this.zodiacSign,
  });
}

class AddNoteScreenArguments {
  final String customerID;
  final String? oldNote;
  final String? updatedAt;
  final VoidCallback noteChanged;

  AddNoteScreenArguments({
    required this.customerID,
    required this.noteChanged,
    this.oldNote,
    this.updatedAt,
  });
}

class ChatScreenArguments {
  final String? clientId;
  final ChatItem? question;
  final String? publicQuestionId;
  final String? privateQuestionId;
  final String? ritualID;
  final String? storyIdForHistory;

  ChatScreenArguments({
    this.clientId,
    this.question,
    this.publicQuestionId,
    this.privateQuestionId,
    this.ritualID,
    this.storyIdForHistory,
  });
}
