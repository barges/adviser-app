import 'package:audible_mode/audible_mode.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

@singleton
class SilentModeService {
  final PublishSubject<bool> silentModeStream = PublishSubject();

  SilentModeService() {
    Audible.audibleStream.listen((event) {
      silentModeStream.add(event == AudibleProfile.SILENT_MODE);
    });
  }
}
