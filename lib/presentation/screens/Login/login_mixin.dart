import 'package:get/get.dart';

mixin LoginMixin {
  bool isEmail(String email) => GetUtils.isEmail(email);

  bool isWeakPassword(String password) {
    //TODO -- check this
    /*
    * 2 letters in upper case
      1 special character (!@#$&*)
      2 numerals (0-9)
      3 letters in lower case
      *
      * =======
      *
      * Need to generate suitable error text..
    * */
    return password.length < 8;
  }
}
