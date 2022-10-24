import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:shared_advisor_interface/presentation/screens/advisor_preview/advisor_preview_screen.dart';
import 'package:shared_advisor_interface/presentation/screens/all_brands/all_brands_screen.dart';
import 'package:shared_advisor_interface/presentation/screens/article_details/article_details_screen.dart';
import 'package:shared_advisor_interface/presentation/screens/balance_and_transactions/balance_and_transactions_screen.dart';
import 'package:shared_advisor_interface/presentation/screens/edit_profile/edit_profile_screen.dart';
import 'package:shared_advisor_interface/presentation/screens/edit_profile/gallery/gallery_pictures_screen.dart';
import 'package:shared_advisor_interface/presentation/screens/forgot_password/forgot_password_screen.dart';
import 'package:shared_advisor_interface/presentation/screens/home/home_screen.dart';
import 'package:shared_advisor_interface/presentation/screens/login/login_screen.dart';
import 'package:shared_advisor_interface/presentation/screens/splash/splash_screen.dart';
import 'package:shared_advisor_interface/presentation/screens/support/support_screen.dart';

class AppRoutes {
  static const splash = '/splash_screen';
  static const login = '/login_screen';
  static const home = '/home_screen';
  static const support = '/support_screen';
  static const forgotPassword = '/forgot_password_screen';
  static const allBrands = '/all_brands_screen';
  static const editProfile = '/edit_profile_screen';
  static const galleryPictures = '/gallery_pictures_screen';
  static const articleDetails = '/article_details_screen';
  static const advisorPreview = '/advisor_preview_screen';
  static const balanceAndTransactions = '/balance_and_transactions_screen';


  static final List<GetPage> getPages = [
    GetPage(
      name: splash,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: home,
      page: () => const HomeScreen(),
    ),
    GetPage(
      name: login,
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: forgotPassword,
      page: () => const ForgotPasswordScreen(),
    ),
    GetPage(
      name: allBrands,
      page: () => const AllBrandsScreen(),
    ),
    GetPage(
      name: editProfile,
      page: () => const EditProfileScreen(),
    ),
    GetPage(
      name: editProfile,
      page: () => const EditProfileScreen(),
    ),
    GetPage(
      name: articleDetails,
      page: () => const ArticleDetailsScreen(),
    ),
    GetPage(
      name: galleryPictures,
      page: () => const GalleryPicturesScreen(),
    ),
    GetPage(
      name: balanceAndTransactions,
      page: () => const BalanceAndTransactionsScreen(),
    ),
    GetPage(
      name: advisorPreview,
      page: () => const AdvisorPreviewScreen(),
    ),
    GetPage(
      name: support,
      page: () => const SupportScreen(),
    ),
  ];
}
