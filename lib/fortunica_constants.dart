class FortunicaConstants{
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
  static const int minNickNameLength = 3;

  static const int questionsLimit = 20;

  static const int maxAttachmentSizeInBytes = 26214400;

  ///STAGE
  static const String baseUrl = 'https://api-staging.fortunica-app.com';
  static const String webToolUrl = 'https://advisor-staging.fortunica-app.com';

  ///DEV
  static const String baseUrlDev =
      'https://fortunica-backend-for-2268.fortunica.adviqodev.de';

  ///PROD
  static const String baseUrlProd = 'https://api.fortunica-app.com';
  static const String webToolUrlProd = 'https://advisor.fortunica-app.com';
}