import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';

class Configuration {
  static const List<Brand> brands = [
    Brand.fortunica,
  ];
}

enum Brand {
  fortunica;

  static Brand brandFromString(String? s) {
    switch (s) {
      case 'Brand.fortunica':
        return Brand.fortunica;
      default:
        return Brand.fortunica;
    }
  }

  static Brand brandFromName(String? s) {
    switch (s) {
      case 'fortunica':
        return Brand.fortunica;
      default:
        return Brand.fortunica;
    }
  }

  String get name {
    switch (this) {
      case Brand.fortunica:
        return 'fortunica';
    }
  }

  String get url {
    switch (this) {
      case Brand.fortunica:
        return '';
    }
  }

  String get icon {
    switch (this) {
      case Brand.fortunica:
        return Assets.vectors.fortunica.path;
    }
  }

  bool get isEnabled {
    switch (this) {
      case Brand.fortunica:
        return true;
    }
  }
}
