import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:zodiac/generated/l10n.dart';

enum MissedMessageAction {
  chat,
  call,
  none;

  String get iconPath {
    switch (this) {
      case chat:
        return Assets.zodiac.chatFee.path;
      case call:
        return Assets.zodiac.callFee.path;
      case none:
        return '';
    }
  }

  String getDescription(BuildContext context, String clientName) {
    switch (this) {
      case MissedMessageAction.chat:
        return SZodiac.of(context).youMissedChatFromZodiac(clientName);
      case MissedMessageAction.call:
        return SZodiac.of(context).youMissedCallFromZodiac(clientName);
      case MissedMessageAction.none:
        return '';
    }
  }
}
