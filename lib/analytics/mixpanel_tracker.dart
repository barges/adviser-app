import 'package:app_install_date/app_install_date_imp.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:shared_advisor_interface/analytics/analytics.dart';
import 'package:shared_advisor_interface/analytics/analytics_event.dart';
import 'package:shared_advisor_interface/analytics/analytics_params.dart';
import 'package:shared_advisor_interface/analytics/analytics_values.dart';
import 'package:shared_advisor_interface/global.dart';

class MixpanelTracker extends AbstractTracker<AnalyticsEvent> {
  Mixpanel? _mixpanel;

  @override
  Future<bool> init() async {
    try {
      _mixpanel =
          await Mixpanel.init(mixpanelToken, trackAutomaticEvents: true);
      await _registerSuperProperties();

      return true;
    } catch (e) {
      logger.d(e);
    }

    return false;
  }

  Future<void> _registerSuperProperties() async {
    String installDate = '';
    try {
      final DateTime date = await AppInstallDate().installDate;
      installDate = date.toUtc().toString();
    } catch (e) {
      logger.d(e);
    }

    _mixpanel?.registerSuperProperties({
      AnalyticsParams.platform: AnalyticsValues.app,
      AnalyticsParams.installDate: installDate,
    });
  }

  @override
  void trackEvent(AnalyticsEvent event) async {
    _mixpanel?.track(event.name, properties: event.params);
  }

  String get mixpanelToken => '';
}
