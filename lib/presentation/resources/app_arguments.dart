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
  final PageController? editProfilePageController;
  final double? initPage;

  GalleryPicturesScreenArguments({
    required this.pictures,
    this.editProfilePageController,
    this.initPage,
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
  final String? customerID;
  final String? clientName;
  final ZodiacSign? zodiacSign;

  const CustomerProfileScreenArguments({
    this.customerID,
    this.clientName,
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
  final String? clientIdFromPush;
  final ChatItem? question;
  final String? publicQuestionId;
  final String? privateQuestionId;
  final String? ritualID;
  final String? storyIdForHistory;

  ChatScreenArguments({
    this.clientIdFromPush,
    this.question,
    this.publicQuestionId,
    this.privateQuestionId,
    this.ritualID,
    this.storyIdForHistory,
  });

  @override
  String toString() {
    return 'ChatScreenArguments{clientIdFromPush: $clientIdFromPush, question: $question, publicQuestionId: $publicQuestionId, privateQuestionId: $privateQuestionId, ritualID: $ritualID, storyIdForHistory: $storyIdForHistory}';
  }
}

class CustomerSessionsScreenArguments {
  ChatItem question;
  int marketIndex;

  CustomerSessionsScreenArguments({
    required this.question,
    required this.marketIndex,
  });
}

class ForceUpdateScreenArguments {
  final String? title;
  final String? description;
  final String? updateLink;
  final String? moreLink;

  ForceUpdateScreenArguments({
    this.title,
    this.description,
    this.updateLink,
    this.moreLink,
  });
}

class EditProfileScreenArguments {
  final bool isAccountTimeout;

  EditProfileScreenArguments({required this.isAccountTimeout});
}

class AdvisorPreviewScreenArguments {
  final bool isAccountTimeout;

  AdvisorPreviewScreenArguments({required this.isAccountTimeout});
}
