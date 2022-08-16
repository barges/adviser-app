import 'package:get/get.dart';

class ForgotPasswordController extends GetxController{

  final RxString email = ''.obs;
  final RxString password = ''.obs;
  final RxString confirmPassword = ''.obs;
  final RxBool hiddenPassword = true.obs;
  final RxBool hiddenConfirmPassword = true.obs;

  bool emailIsValid() => GetUtils.isEmail(email.value);

  bool passwordIsValid() => password.value.length >= 8;

  bool confirmPasswordIsValid() => password.value.length >= 8;

}