import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'inject_config.config.dart';

///Configuration file to get started with injectable and get it

final zodiacGetIt = GetIt.asNewInstance();

@InjectableInit(
  generateForDir: ['lib'],
  initializerName: r'$initGetIt', // default
  preferRelativeImports: true, // default
  asExtension: false, // default
)
Future<void> configureDependenciesZodiac() => $initGetIt(zodiacGetIt);
