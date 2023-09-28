import 'package:shared_advisor_interface/analytics/analytics_event.dart';

abstract class AbstractTracker<E> {
  Future<bool> init();
  void trackEvent(AnalyticsEvent event);
}

abstract class Analytics {
  void trackEvent(AnalyticsEvent event);
}

class AnalyticsBrand extends Analytics {
  late final Future<void> _initialization;
  late final List<AbstractTracker> trackers;

  AnalyticsBrand() {
    _initialization = Future<void>(() async {
      setTrackers();
      await Future.wait(trackers.map((tracker) => tracker.init()).toList());
    });
  }

  void setTrackers() {}

  Future<void> init() {
    return _initialization;
  }

  @override
  void trackEvent(AnalyticsEvent event) {
    for (final AbstractTracker tracker in trackers) {
      tracker.trackEvent(event);
    }
  }
}
