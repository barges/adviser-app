import 'dart:async';

import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:shared_advisor_interface/data/cache/caching_manager.dart';
import 'package:shared_advisor_interface/data/models/app_errors/app_error.dart';
import 'package:shared_advisor_interface/data/models/app_errors/ui_error_type.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/resources/app_arguments.dart';
import 'package:shared_advisor_interface/presentation/resources/app_routes.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs_types.dart';

const String _messageKey = 'message';
const String _statusKey = 'status';
const String _localizedMessageKey = 'localizedMessage';
const String _titleKey = 'title';
const String _descriptionKey = 'description';
const String _updateLinkKey = 'update_link';
const String _moreLinkKey = 'more_link';

class AppInterceptor extends Interceptor {
  final MainCubit _mainCubit;
  final CachingManager _cachingManager;

  AppInterceptor(this._mainCubit, this._cachingManager);

  @override
  FutureOr<dynamic> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    _mainCubit.clearErrorMessage();
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

    if (err.response?.statusCode == 426) {
      final Map<String, dynamic> data = err.response?.data;

      final arguments = ForceUpdateScreenArguments(
        title: data[_titleKey],
        description: data[_descriptionKey],
        updateLink: data[_updateLinkKey],
        moreLink: data[_moreLinkKey],
      );

      Get.offNamedUntil(
        AppRoutes.forceUpdate,
        arguments: arguments,
        (route) => false,
      );
    }
    if (err.response?.statusCode == 401) {
      if (Get.currentRoute != AppRoutes.login) {
        _cachingManager.logout(
          _mainCubit.state.currentBrand,
        );
        Get.offNamedUntil(
          AppRoutes.login,
          (route) => false,
        );
        _mainCubit.updateErrorMessage(
          UIError(uiErrorType: UIErrorType.blocked),
        );
      } else {
        _mainCubit.updateErrorMessage(
          UIError(
            uiErrorType: UIErrorType.wrongUsernameAndOrPassword,
          ),
        );
      }
    } else if (err.response?.statusCode == 400 &&
        Get.currentRoute == AppRoutes.login) {
      _mainCubit.updateErrorMessage(
        UIError(uiErrorType: UIErrorType.blocked),
      );
    } else if (err.response?.statusCode == 451 ||
        err.response?.statusCode == 428) {
      Get.offNamedUntil(
          AppRoutes.home,
          arguments: HomeScreenArguments(
            initTab: TabsTypes.account,
          ),
          (route) => false);
    } else if (err.response?.statusCode == 413) {
      // Handele error 413 Request Entity Too Large in chat_cubit.dart
    } else if (err.type == DioErrorType.connectTimeout ||
        err.type == DioErrorType.receiveTimeout ||
        err.type == DioErrorType.sendTimeout ||
        err.type == DioErrorType.other) {
      _mainCubit.updateErrorMessage(
        UIError(
          uiErrorType: UIErrorType.checkYourInternetConnection,
        ),
      );
    } else {
      try {
        _mainCubit.updateErrorMessage(
          NetworkError(
            message: err.response?.data[_localizedMessageKey] ??
                err.response?.data[_messageKey] ??
                err.response?.data[_statusKey],
          ),
        );
      } catch (e) {
        _mainCubit.updateErrorMessage(
          const NetworkError(),
        );
      }
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
