import 'package:shared_advisor_interface/analytics/analytics.dart';
import 'package:shared_advisor_interface/analytics/mixpanel_tracker.dart';
import 'package:shared_advisor_interface/app_constants.dart';

class MixpanelTrackerZodiac extends MixpanelTracker {
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
