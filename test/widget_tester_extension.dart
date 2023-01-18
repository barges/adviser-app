import 'package:flutter_test/flutter_test.dart';

extension PumpAndSettleWithTimeout on WidgetTester {
  Future<void> pumpNtimes({int times = 3}) async {
    return await Future.forEach(
        Iterable.generate(times), (_) async => await pump());
  }
}
