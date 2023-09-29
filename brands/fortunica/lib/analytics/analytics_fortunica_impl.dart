import 'package:shared_advisor_interface/analytics/analytics.dart';
import 'package:shared_advisor_interface/analytics/mixpanel_tracker.dart';

class MixpanelTrackerFortunica extends MixpanelTracker {
  @override
  String get mixpanelToken => '';
}

class AnalyticsFortunicaImpl extends AnalyticsBrand {
  @override
  void setTrackers() {
    trackers = [
      MixpanelTrackerFortunica(),
    ];
  }
}
