class ZodiacConstants {
  static const double chatHorizontalPadding = 12.0;
  static const double chatVerticalPadding = 12.0;

  static const String sideMenuUrl = 'www.zodiacpsychics.com';

  static const int serviceTitleIndex = 0;
  static const int serviceDescriptionIndex = 1;
  static const double serviceMinDiscount = 5;
  static const double serviceMaxDiscount = 50;
  static const int serviceDescriptionMaxLength = 280;
  static const int cannedMessageMaxLength = 280;

  ///STAGE
  static const String baseUrlZodiac = 'https://stage.zodiacpsychics.com/api';
  static const String socketUrlZodiacStage = 'stage.zodiacpsychics.com';
  static const List<String> socketUrlsZodiacStage = [
    socketUrlZodiacStage,
    'wsstage.zodiacpsychics.com',
    'wsstage.psiquicos.net'
  ];

  ///DEV
  static const String baseUrlZodiacDev = 'https://dev.zodiacpsychics.com/api';
  static const String socketUrlZodiacDev = 'dev.zodiacpsychics.com';
  static const List<String> socketUrlsZodiacDev = [
    socketUrlZodiacDev,
    'wsdev.zodiacpsychics.com',
    'wsdev.psiquicos.net'
  ];

  /// PROD
  static const List<String> socketUrlsZodiacProd = [
    'ws.zodiacpsychics.com',
    'ws.psiquicos.net'
  ];
}
