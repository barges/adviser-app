import 'package:shared_advisor_interface/analytics/analytics.dart';

class Events {
  static AnalyticsEvent test({
    required String test,
  }) {
    var params = {
      "test": test,
    };

    return AnalyticsEvent(name: "Name Event", params: params);
  }
}
