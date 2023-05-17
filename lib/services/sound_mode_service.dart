import 'package:audible_mode/audible_mode.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

@singleton
class SoundModeService {
  final PublishSubject<DeviceSoundMode> soundModeStream = PublishSubject();

  SoundModeService() {
    Audible.audibleStream.listen((event) {
      DeviceSoundMode soundMode = DeviceSoundMode.fromAudibleProfile(event);

      soundModeStream.add(soundMode);
    });
  }

  Future<DeviceSoundMode> get soundMode async {
    final AudibleProfile? profile = await Audible.getAudibleProfile;
    return DeviceSoundMode.fromAudibleProfile(profile);
  }
}

enum DeviceSoundMode {
  silent,
  vibrate,
  normal,
  undefined;

  static DeviceSoundMode fromAudibleProfile(AudibleProfile? profile) {
    switch (profile) {
      case AudibleProfile.SILENT_MODE:
        return DeviceSoundMode.silent;
      case AudibleProfile.VIBRATE_MODE:
        return DeviceSoundMode.vibrate;
      case AudibleProfile.NORMAL_MODE:
        return DeviceSoundMode.normal;
      default:
        return DeviceSoundMode.undefined;
    }
  }
}
