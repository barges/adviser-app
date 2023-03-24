import 'package:shared_advisor_interface/infrastructure/flavor/flavor_config.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';

import 'app_binding.dart';

///Will have everything needs to be configured before the app run
class ZodiacAppInitializer {
  static Future setupPrerequisites(
      Flavor flavor) async {
    ///dependencies injection
    await AppBinding.setupInjection(flavor);
  }
}
