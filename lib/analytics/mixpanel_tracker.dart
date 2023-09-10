import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:shared_advisor_interface/analytics/analytics.dart';
import 'package:shared_advisor_interface/global.dart';

class MixpanelTracker extends AbstractTracker<AnalyticsEvent> {
  Mixpanel? _mixpanel;

  @override
  Future<bool> init() async {
    try {
      _mixpanel =
          await Mixpanel.init(mixpanelToken, trackAutomaticEvents: false);
      return true;
    } catch (e) {
      logger.d(e);
    }

    return false;
  }

  @override
  void trackEvent(AnalyticsEvent event) async {
    _mixpanel?.track(event.name, properties: event.params);
  }

  String get mixpanelToken => '';
}
