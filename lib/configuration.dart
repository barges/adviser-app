import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';

class Configuration {
  static const List<Brand> brands = [
    Brand.fortunica,
    Brand.zodiacPsychics,
  ];
}

enum Brand {
  fortunica,
  zodiacPsychics;

  static Brand brandFromString(String? s) {
    switch (s) {
      case 'Brand.fortunica':
        return Brand.fortunica;
      case 'Brand.zodiacPsychics':
        return Brand.zodiacPsychics;
      default:
        return Brand.fortunica;
    }
  }

  static Brand brandFromName(String? s) {
    switch (s) {
      case 'fortunica':
        return Brand.fortunica;
      case 'zodiacPsychics':
        return Brand.zodiacPsychics;
      default:
        return Brand.fortunica;
    }
  }

  String get name {
    switch (this) {
      case Brand.fortunica:
        return 'Fortunica';
      case Brand.zodiacPsychics:
        return 'Zodiac Psychics';
    }
  }

  String get url {
    switch (this) {
      case Brand.fortunica:
        return '';
      case Brand.zodiacPsychics:
        return 'www.zodiacpsychics.com';
    }
  }

  String get icon {
    switch (this) {
      case Brand.fortunica:
        return Assets.vectors.fortunica.path;
      case Brand.zodiacPsychics:
        return Assets.vectors.zodiacTouch.path;
    }
  }

  bool get isEnabled {
    switch (this) {
      case Brand.fortunica:
        return true;
      case Brand.zodiacPsychics:
        return false;
    }
  }

  static List<String> allBrands = [
    Assets.images.brands.bitWine.path,
    Assets.images.brands.purpleGarden.path,
    Assets.images.brands.purpleTides.path,
    Assets.images.brands.purpleOcean.path,
    Assets.images.brands.zodiacPsychics.path,
    Assets.images.brands.theraPeer.path,
    Assets.images.brands.fortunica.path,
  ];
}
