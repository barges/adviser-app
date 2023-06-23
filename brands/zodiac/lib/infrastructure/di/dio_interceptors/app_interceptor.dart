import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_advisor_interface/data/models/app_error/app_error.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.gr.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:zodiac/data/cache/zodiac_caching_manager.dart';
import 'package:zodiac/data/models/app_error/app_error.dart';
import 'package:zodiac/data/models/app_error/ui_error_type.dart';
import 'package:zodiac/data/network/responses/base_response.dart';
import 'package:zodiac/services/websocket_manager/websocket_manager.dart';
import 'package:zodiac/zodiac.dart';
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
  final ZodiacCachingManager _cachingManager;
  final WebSocketManager _webSocketManager;

  AppInterceptor(
    this._mainCubit,
    this._zodiacMainCubit,
    this._cachingManager,
    this._webSocketManager,
  );

  @override
  FutureOr<dynamic> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    _zodiacMainCubit.clearErrorMessage();
    if (!options.path.contains('/entities') &&
        !options.path.contains("/images")) {
      _mainCubit.updateIsLoading(true);
    }
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
    } else if (err.type == DioErrorType.connectionTimeout ||
        err.type == DioErrorType.receiveTimeout ||
        err.type == DioErrorType.sendTimeout ||
        err.type == DioErrorType.unknown) {
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

    final BuildContext? context = ZodiacBrand().context;

    BaseResponse baseResponse = BaseResponse.fromJson(response.data);

    if (baseResponse.errorCode == 5) {
      _webSocketManager.close();
      await _cachingManager.logout();
      context?.replaceAll([const ZodiacAuth()]);
    } else if (response.realUri.path.contains('login') &&
        baseResponse.errorCode == 4) {
      _zodiacMainCubit.updateErrorMessage(
          UIError(uiErrorType: UIErrorType.loginDetailsSeemToBeIncorrect));
    } else if (response.realUri.path.contains('edit-phone-number') &&
        baseResponse.errorCode == 11) {
      _zodiacMainCubit.updateErrorMessage(
        UIError(
          uiErrorType: UIErrorType.youveReachedLimitPhone,
        ),
      );
    } else if (baseResponse.errorCode != 0 &&
        !response.realUri.path.contains('forgot-password')) {
      if (baseResponse.errorCode == 15) {
        _zodiacMainCubit.updateErrorMessage(
          UIError(
            uiErrorType: UIErrorType.youWhereBlocked,
          ),
        );
      } else {
        _zodiacMainCubit.updateErrorMessage(
          NetworkError(
            message: baseResponse.getErrorMessage(),
          ),
        );
      }
    }
    return super.onResponse(response, handler);
  }
}
