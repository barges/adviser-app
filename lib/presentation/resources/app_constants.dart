class AppConstants {
  static const String fortunicaIosAppId = '1164888500';

  static const double textFieldsHeight = 48.0;
  static const double buttonRadius = 12.0;
  static const double iconSize = 24.0;
  static const double iconButtonSize = 32.0;
  static const double logoSize = 242.0;
  static const double horizontalScreenPadding = 16.0;
  static const double appBarHeight = 52.0;

  static const int minNickNameLength = 3;

  static const int millisecondsInHour = 3600000;
  static const int questionsLimit = 20;

  static const int maxAttachedPictures = 1;
  static const int minAttachedPictures = 1;

  static const int minRecordDurationInSec = 15;
  static const int maxRecordDurationInSec = 360;

  static const int minTextLength = 250;
  static const int maxTextLength = 2000;
  static const int minTextLengthRitual = 1000;
  static const int maxTextLengthRitual = 20000;

  static const int minuteInSec = 60;
  static const int tillShowAnswerTimingMessagesInSec = 25 * minuteInSec;
  static const int afterShowAnswerTimingMessagesInSec = 5 * minuteInSec;

  static const int bytesInKilobyte = 1024;
  static const int maxAttachmentSizeInBytes = 26214400;
  static const int minFreeSpaceInMb = 3;

  static const String enBrandName = 'English';
  static const String esBrandName = 'Español';
  static const String ptBrandName = 'Português';
  static const String deBrandName = 'Deutsch';

  static const String firebaseProjectId = 'reader-app-fortunica';
  static const String iosApiKey = 'AIzaSyCj0OVmpL96tU3WQLYJjqgCh6Af2gEoMa0';
  static const String firebaseMessagingSenderId = '986930839057';
  static const String iosAppId = '1:986930839057:ios:931a04b3aeb905de5cbbb0';

  ///STAGE
  static const String baseUrlStage = 'https://api-staging.fortunica-app.com';
  static const String webToolUrl = 'https://advisor-staging.fortunica-app.com';

  ///DEV
  static const String baseUrlDev =
      'https://fortunica-backend-for-2268.fortunica.adviqodev.de';

  ///PROD
  static const String baseUrlProd = 'https://api.fortunica-app.com';
  static const String webToolUrlProd = 'https://advisor.fortunica-app.com';
}
