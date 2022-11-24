import 'package:json_annotation/json_annotation.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';

enum MarketsType {
  de,
  en,
  es,
  pt,
  all,
  // @JsonValue("en-US")
  // enUs,
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
        return 'Deutsch';
      case MarketsType.en:
        return 'English';
      case MarketsType.es:
        return 'Español';
      case MarketsType.pt:
        return 'Português';
      case MarketsType.all:
        return S.current.allType;
    }
  }
}
