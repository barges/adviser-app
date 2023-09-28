import 'package:shared_advisor_interface/analytics/analytics.dart';
import 'package:shared_advisor_interface/analytics/analytics_event.dart';
import 'package:shared_advisor_interface/analytics/mixpanel_tracker.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:zodiac/data/cache/zodiac_caching_manager.dart';
import 'package:zodiac/infrastructure/di/inject_config.dart';
import 'package:zodiac/zodiac.dart';

class MixpanelTrackerZodiac extends MixpanelTracker {
  @override
  void trackEvent(AnalyticsEvent event) async {
    if (event.params != null) {
      event.setParams(
        event.params!,
        ZodiacBrand(),
        zodiacGetIt.get<ZodiacCachingManager>(),
      );
    }

    super.trackEvent(event);
  }

  @override
  String get mixpanelToken => AppConstants.mixpanelTokenZodiac;
}

class AnalyticsZodiacImpl extends AnalyticsBrand {
  @override
  void setTrackers() {
    trackers = [
      MixpanelTrackerZodiac(),
    ];
  }
}
