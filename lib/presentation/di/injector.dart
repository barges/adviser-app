import 'package:shared_advisor_interface/presentation/di/modules/module.dart';

class Injector {
  static Injector? _instance = Injector._();

  static Injector get instance {
    _instance ??= Injector._();
    return _instance!;
  }

  Injector._();

  Future<void> inject(List<Module> modules) async {
    for (var m in modules) {
      await m.dependency();
    }
  }
}
