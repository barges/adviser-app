import 'dart:async';

import 'package:shared_advisor_interface/data/cache/global_caching_manager.dart';
import 'package:shared_advisor_interface/data/models/app_error/app_error.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:zodiac/data/models/app_error/app_error.dart';
import 'package:zodiac/data/models/app_error/ui_error_type.dart';
import 'package:zodiac/data/network/responses/base_response.dart';
import 'package:zodiac/zodiac_main_cubit.dart';

const String _messageKey = 'message';
const String _statusKey = 'status';
const String _localizedMessageKey = 'localizedMessage';
const String _titleKey = 'title';
const String _descriptionKey = 'description';
const String _updateLinkKey = 'update_link';
const String _moreLinkKey = 'more_link';

@singleton
class AppInterceptor extends Interceptor {
  final MainCubit _mainCubit;
  final ZodiacMainCubit _zodiacMainCubit;
  final GlobalCachingManager _cachingManager;

  AppInterceptor(this._mainCubit, this._zodiacMainCubit, this._cachingManager);

  @override
  FutureOr<dynamic> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    _zodiacMainCubit.clearErrorMessage();
    _mainCubit.updateIsLoading(true);
    return super.onRequest(options, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    _mainCubit.updateIsLoading(false);

    if (err.response?.statusCode == 426) {
      final Map<String, dynamic> data = err.response?.data;

      // final arguments = ForceUpdateScreenArguments(
      //   title: data[_titleKey],
      //   description: data[_descriptionKey],
      //   updateLink: data[_updateLinkKey],
      //   moreLink: data[_moreLinkKey],
      // );

      // Get.offNamedUntil(
      //   AppRoutes.forceUpdate,
      //   arguments: arguments,
      //   (route) => false,
      // );
    }
    if (err.response?.statusCode == 401) {
      //  if (Get.currentRoute != AppRoutes.login) {
      // //   _cachingManager.logout(
      // //     _mainCubit.state.currentBrand,
      // //   );
      // //   Get.offNamedUntil(
      // //     AppRoutes.login,
      // //     (route) => false,
      // //   );
      //   _fortunicaMainCubit.updateErrorMessage(
      //     UIError(uiErrorType: UIErrorType.blocked),
      //   );
      // } else {
      //   _fortunicaMainCubit.updateErrorMessage(
      //     UIError(
      //       uiErrorType: UIErrorType.wrongUsernameAndOrPassword,
      //     ),
      //   );
      // }
    } else if (err.response?.statusCode == 451 ||
        err.response?.statusCode == 428) {
      // Get.offNamedUntil(
      //     AppRoutes.home,
      //     arguments: HomeScreenArguments(
      //       initTab: TabsTypes.account,
      //     ),
      //     (route) => false);
    } else if (err.response?.statusCode == 413) {
      // Handele error 413 Request Entity Too Large in chat_cubit.dart
    } else if (err.type == DioErrorType.connectTimeout ||
        err.type == DioErrorType.receiveTimeout ||
        err.type == DioErrorType.sendTimeout) {
      _zodiacMainCubit.updateErrorMessage(
        UIError(
          uiErrorType: UIErrorType.checkYourInternetConnection,
        ),
      );
    } else {
      try {
        _zodiacMainCubit.updateErrorMessage(
          NetworkError(
            message: err.response?.data[_localizedMessageKey] ??
                err.response?.data[_messageKey] ??
                err.response?.data[_statusKey],
          ),
        );
      } catch (e) {
        _zodiacMainCubit.updateErrorMessage(
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

    BaseResponse baseResponse = BaseResponse.fromJson(response.data);

    if (response.realUri.path.contains('login') &&
        baseResponse.errorCode == 4) {
      _zodiacMainCubit.updateErrorMessage(
          UIError(uiErrorType: UIErrorType.loginDetailsSeemToBeIncorrect));
    } else if (baseResponse.errorCode != 0 &&
        !response.realUri.path.contains('forgot-password')) {
      _zodiacMainCubit.updateErrorMessage(
        NetworkError(
          message: baseResponse.getErrorMessage(),
        ),
      );
    }
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
