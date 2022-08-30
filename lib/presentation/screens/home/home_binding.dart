import 'package:get/get.dart';
import 'package:shared_advisor_interface/presentation/screens/home/home_controller.dart';

class HomeBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
  }
}