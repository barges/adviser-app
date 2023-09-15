import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:zodiac/generated/l10n.dart';

enum ServiceType {
  online,
  offline;

  static ServiceType fromInt(int value) {
    switch (value) {
      case 0:
        return ServiceType.offline;
      case 1:
        return ServiceType.online;
      default:
        return ServiceType.offline;
    }
  }

  static int toInt(ServiceType value) {
    switch (value) {
      case ServiceType.offline:
        return 0;
      case ServiceType.online:
        return 1;
    }
  }

  String getTitle(BuildContext context) {
    switch (this) {
      case online:
        return SZodiac.of(context).onlineServiceTabZodiac;
      case offline:
        return SZodiac.of(context).offlineServiceTabZodiac;
    }
  }

  String getShortTitle(BuildContext context) {
    switch (this) {
      case online:
        return SZodiac.of(context).onlineZodiac;
      case offline:
        return SZodiac.of(context).offlineZodiac;
    }
  }

  String get iconPath {
    switch (this) {
      case online:
        return Assets.zodiac.vectors.onlineService.path;
      case offline:
        return Assets.zodiac.vectors.narrowServicesIcon.path;
    }
  }
}
