import 'package:injectable/injectable.dart';
import 'package:shared_advisor_interface/global.dart';

import 'inject_config.config.dart';

///Configuration file to get started with injectable and get it

@InjectableInit(
  initializerName: r'$initGetIt', // default
  preferRelativeImports: true, // default
  asExtension: false, // default
)
Future<void> configureDependencies() async => $initGetIt(globalGetIt);
