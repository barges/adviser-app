import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_advisor_interface/global.dart';

import 'inject_config.config.dart';

///Configuration file to get started with injectable and get it

@InjectableInit(
  //generateForDir: ['lib'],
  initializerName: r'$initGetIt', // default
  preferRelativeImports: true, // default
  asExtension: false, // default
)
//Future<void> configureDependencies() async => $initGetIt(globalGetIt);

Future<void> configureDependenciesFortunica() async =>
    $initGetIt(globalGetIt);
