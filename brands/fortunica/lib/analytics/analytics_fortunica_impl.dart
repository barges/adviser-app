import 'package:shared_advisor_interface/analytics/analytics.dart';
import 'package:shared_advisor_interface/analytics/mixpanel_tracker.dart';
import 'package:shared_advisor_interface/app_constants.dart';

class MixpanelTrackerFortunica extends MixpanelTracker {
  @override
  String get mixpanelToken => AppConstants.mixpanelTokenFortunica;
}

class AnalyticsFortunicaImpl extends AnalyticsBrand {
  @override
  void setTrackers() {
    trackers = [
      MixpanelTrackerFortunica(),
    ];
  }
}
