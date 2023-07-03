import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zodiac/generated/l10n.dart';

extension CategoryEmojiExt on Category {
  IconData get icon {
    switch (this) {
      case Category.RECENT:
        return CupertinoIcons.clock;
      case Category.SMILEYS:
        return CupertinoIcons.smiley;
      case Category.ANIMALS:
        return CupertinoIcons.paw;
      case Category.FOODS:
        return Icons.fastfood;
      case Category.ACTIVITIES:
        return Icons.directions_run;
      case Category.TRAVEL:
        return Icons.location_city;
      case Category.OBJECTS:
        return CupertinoIcons.lightbulb;
      case Category.SYMBOLS:
        return CupertinoIcons.heart;
      case Category.FLAGS:
        return CupertinoIcons.flag;
    }
  }

  String getTitle(BuildContext context) {
    switch (this) {
      case Category.RECENT:
        return SZodiac.of(context).recentlyUsedZodiac;
      case Category.SMILEYS:
        return SZodiac.of(context).smileysAndPeopleZodiac;
      case Category.ANIMALS:
        return SZodiac.of(context).animalsAndNatureZodiac;
      case Category.FOODS:
        return SZodiac.of(context).foodAndDrinkZodiac;
      case Category.ACTIVITIES:
        return SZodiac.of(context).activityZodiac;
      case Category.TRAVEL:
        return SZodiac.of(context).travelAndPlacesZodiac;
      case Category.OBJECTS:
        return SZodiac.of(context).objectsZodiac;
      case Category.SYMBOLS:
        return SZodiac.of(context).symbolsZodiac;
      case Category.FLAGS:
        return SZodiac.of(context).flagsZodiac;
    }
  }
}
