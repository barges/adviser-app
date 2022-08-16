import 'package:get/get.dart';
import 'package:shared_advisor_interface/presentation/screens/login/login_controller.dart';

class LoginBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());
  }

}