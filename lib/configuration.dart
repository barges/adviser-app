import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';

class Configuration {
  static const List<Brand> brands = [
    Brand.fortunica,
    Brand.zodiacTouch,
  ];
}

enum Brand {
  fortunica,
  zodiacTouch;

  static Brand brandFromString(String? s) {
    switch (s) {
      case 'Brand.fortunica':
        return Brand.fortunica;
      case 'Brand.zodiacTouch':
        return Brand.zodiacTouch;
      default:
        return Brand.fortunica;
    }
  }

  String get name {
    switch (this) {
      case Brand.fortunica:
        return 'Fortunica';
      case Brand.zodiacTouch:
        return 'Zodiac Touch';
    }
  }

  String get url {
    switch (this) {
      case Brand.fortunica:
        return '';
      case Brand.zodiacTouch:
        return 'www.zodiacpsychics.com';
    }
  }

  String get icon {
    switch (this) {
      case Brand.fortunica:
        return Assets.vectors.fortunica.path;
      case Brand.zodiacTouch:
        return Assets.vectors.zodiacTouch.path;
    }
  }

  bool get isEnabled {
    switch (this) {
      case Brand.fortunica:
        return true;
      case Brand.zodiacTouch:
        return false;
    }
  }

  static List<String> allBrands = [
    Assets.images.brands.keen.path,
    Assets.images.brands.bitWine.path,
    Assets.images.brands.purpleGarden.path,
    Assets.images.brands.purpleTides.path,
    Assets.images.brands.purpleOcean.path,
    Assets.images.brands.viversum.path,
    Assets.images.brands.kosmica.path,
    Assets.images.brands.kang.path,
    Assets.images.brands.horoscope.path,
    Assets.images.brands.expertCall.path,
    Assets.images.brands.astrologyCom.path,
    Assets.images.brands.horoskopDe.path,
    Assets.images.brands.horoscopoCom.path,
    Assets.images.brands.psychicCenter.path,
    Assets.images.brands.sunSigns.path,
    Assets.images.brands.zodiacPsychics.path,
    Assets.images.brands.psiquicos.path,
    Assets.images.brands.questico.path,
    Assets.images.brands.cocoTarot.path,
    Assets.images.brands.theCircle.path,
    Assets.images.brands.liveAdvice.path,
    Assets.images.brands.astroTv.path,
    Assets.images.brands.theraPeer.path,
    Assets.images.brands.gluckskeks.path,
    Assets.images.brands.fortunica.path,
    Assets.images.brands.astroDe.path,
    Assets.images.brands.horoscopeFriends.path,
    Assets.images.brands.zukunftsBlick.path,
  ];
}
