import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';

enum MarketsType {
  de,
  en,
  es,
  pt,
  all,
}

extension MarketsTypeExt on MarketsType {
  String get flagImagePath {
    switch (this) {
      case MarketsType.de:
        return Assets.images.flags.german.path;
      case MarketsType.en:
        return Assets.images.flags.english.path;
      case MarketsType.es:
        return Assets.images.flags.spanish.path;
      case MarketsType.pt:
        return Assets.images.flags.portugues.path;
      case MarketsType.all:
        return '';
    }
  }

  String get languageName {
    switch (this) {
      case MarketsType.de:
        return 'German';
      case MarketsType.en:
        return 'English';
      case MarketsType.es:
        return 'Spanish';
      case MarketsType.pt:
        return 'Portuguese';
      case MarketsType.all:
        return S.current.allType;
    }
  }
}
