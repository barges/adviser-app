import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:shared_advisor_interface/presentation/screens/all_brands/all_brands_screen.dart';
import 'package:shared_advisor_interface/presentation/screens/forgot_password/forgot_password_binding.dart';
import 'package:shared_advisor_interface/presentation/screens/forgot_password/forgot_password_screen.dart';
import 'package:shared_advisor_interface/presentation/screens/home/home_binding.dart';
import 'package:shared_advisor_interface/presentation/screens/home/home_screen.dart';
import 'package:shared_advisor_interface/presentation/screens/login/login_screen.dart';
import 'package:shared_advisor_interface/presentation/screens/splash/splash_screen.dart';

class AppRoutes {
  static const splash = '/splash_screen';
  static const login = '/login_screen';
  static const home = '/home_screen';
  static const forgotPassword = '/forgot_password_screen';
  static const allBrands = '/all_brands_screen';


  static final List<GetPage> getPages = [
    GetPage(
      name: splash,
      page: () => SplashScreen(),
    ),
    GetPage(
      name: home,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: login,
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: forgotPassword,
      page: () => const ForgotPasswordScreen(),
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
      name: allBrands,
      page: () => const AllBrandsScreen(),
    ),
  ];
}
