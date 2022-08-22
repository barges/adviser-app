import 'package:shared_advisor_interface/presentation/resources/app_icons.dart';

class Configuration {

  static const List<Brand> brands = [
    Brand.fortunica,
    Brand.zodiacTouch,
    Brand.fortunica,
    Brand.zodiacTouch,
    Brand.fortunica,
    Brand.zodiacTouch,
    Brand.fortunica,
    Brand.zodiacTouch,
    Brand.fortunica,
    Brand.zodiacTouch,
    Brand.fortunica,
    Brand.zodiacTouch,
    Brand.fortunica,
    Brand.zodiacTouch,
    Brand.fortunica,
    Brand.zodiacTouch,
  ];
}

enum Brand { fortunica, zodiacTouch}

extension BrandExtension on Brand {
  String get name {
    switch (this) {
      case Brand.fortunica:
        return 'Fortunica';
      case Brand.zodiacTouch:
        return 'Zodiac Touch';
    }
  }

  String get icon {
    switch (this) {
      case Brand.fortunica:
        return AppIcons.fortunica;
      case Brand.zodiacTouch:
        return AppIcons.zodiacTouch;
    }
  }

  bool get isEnabled {
    switch (this) {
      case Brand.fortunica:
        return true;
      case Brand.zodiacTouch:
        return true;
    }
  }

}
