import 'dart:async';

import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:shared_advisor_interface/data/cache/caching_manager.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/resources/app_arguments.dart';
import 'package:shared_advisor_interface/presentation/resources/app_routes.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs_types.dart';

class AppInterceptor extends Interceptor {
  final MainCubit _mainCubit;
  final CachingManager _cachingManager;

  AppInterceptor(this._mainCubit, this._cachingManager);

  @override
  FutureOr<dynamic> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    _mainCubit.clearErrorMessage();
    _mainCubit.clearSuccessMessage();
    _mainCubit.updateIsLoading(true);
    // if (options.headers.containsKey("requiresToken")) {
    //   //remove the auxiliary header
    //   options.headers.remove("requiresToken");
    //
    //   SharedPreferences prefs = await SharedPreferences.getInstance();
    //   var header = prefs.get("Header");
    //
    //   options.headers.addAll({"Header": "$header${DateTime.now()}"});
    //
    //   return options;
    // }
    return super.onRequest(options, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    _mainCubit.updateIsLoading(false);
    if (err.response?.statusCode == 401) {
      if (Get.currentRoute != AppRoutes.login) {
        _mainCubit.updateErrorMessage(
          S.current.yourAccountHasBeenBlockedPleaseContactYourAdvisorManager,
        );
        _cachingManager.clearTokenForBrand(
          _mainCubit.state.currentBrand,
        );
        Get.offNamedUntil(AppRoutes.login, (route) => false);
      } else {
        _mainCubit.updateErrorMessage(
          S.current.wrongUsernameOrPassword,
        );
      }
    } else if (err.response?.statusCode == 451 ||
        err.response?.statusCode == 428) {
      Get.offNamedUntil(
          AppRoutes.home,
          arguments: HomeScreenArguments(
            initTab: TabsTypes.account,
          ),
          (route) => false);
    } else {
      _mainCubit.updateErrorMessage(
        err.response?.data['localizedMessage'] ??
            err.response?.data['message'] ??
            err.response?.data['status'] ??
            'Unknown dio error',
      );
    }
    return super.onError(err, handler);
  }

  @override
  FutureOr<dynamic> onResponse(
      Response response, ResponseInterceptorHandler handler) async {
    _mainCubit.updateIsLoading(false);
    // if (response.headers.value("verifyToken") != null) {
    //   //if the header is present, then compare it with the Shared Prefs key
    //   SharedPreferences prefs = await SharedPreferences.getInstance();
    //   var verifyToken = prefs.get("VerifyToken");
    //
    //   // if the value is the same as the header, continue with the request
    //   if (response.headers.value("verifyToken") == verifyToken) {
    //     return response;
    //   }
    // }
    //
    // return DioError(
    //     request: response.request, message: "User is no longer active");
    return super.onResponse(response, handler);
  }
}
