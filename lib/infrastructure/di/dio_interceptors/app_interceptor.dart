import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import 'package:injectable/injectable.dart';

import '../../../infrastructure/routing/app_router.dart';
import '../../../data/cache/fortunica_caching_manager.dart';
import '../../../data/models/app_error/app_error.dart';
import '../../../data/models/app_error/ui_error_type.dart';
import '../../../data/network/api/chats_api.dart';
import '../../../main.dart';
import '../../../main_cubit.dart';
import '../../../presentation/screens/force_update/force_update_screen.dart';
import '../../routing/app_router.gr.dart';
import '../../routing/route_paths_fortunica.dart';

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
  final FortunicaCachingManager _cachingManager;

  AppInterceptor(this._mainCubit, this._cachingManager);

  @override
  FutureOr<dynamic> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    _mainCubit.clearErrorMessage();
    _mainCubit.updateIsLoading(true);
    return super.onRequest(options, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    final BuildContext? fortunicaContext = currentContext;
    _mainCubit.updateIsLoading(false);
    if (fortunicaContext != null) {
      final bool isLogin =
          fortunicaContext.currentRoutePath == RoutePathsFortunica.loginScreen;

      if (err.response?.statusCode == 426) {
        final Map<String, dynamic> data = err.response?.data;

        final arguments = ForceUpdateScreenArguments(
          title: data[_titleKey],
          description: data[_descriptionKey],
          updateLink: data[_updateLinkKey],
          moreLink: data[_moreLinkKey],
        );

        fortunicaContext.replaceAllRoot(
          [
            ForceUpdate(
              forceUpdateScreenArguments: arguments,
            ),
          ],
        );
      } else if (err.response?.statusCode == 401) {
        if (!isLogin) {
          _cachingManager.logout().then((value) {
            fortunicaContext.replaceAll([const FortunicaLogin()]);
            _mainCubit.updateErrorMessage(
              UIError(uiErrorType: UIErrorType.blocked),
            );
          });
        } else {
          _mainCubit.updateErrorMessage(
            UIError(
              uiErrorType: UIErrorType.wrongUsernameAndOrPassword,
            ),
          );
        }
      } else if (err.response?.statusCode == 400 && isLogin) {
        _mainCubit.updateErrorMessage(
          UIError(uiErrorType: UIErrorType.blocked),
        );
      } else if (err.response?.statusCode == 451 ||
          err.response?.statusCode == 428) {
        fortunicaContext.replaceAll(
          [
            const FortunicaLogin(),
          ],
        );
      } else if (err.type == DioErrorType.connectionTimeout ||
          err.type == DioErrorType.receiveTimeout ||
          err.type == DioErrorType.sendTimeout ||
          err.type == DioErrorType.unknown) {
        _mainCubit.updateErrorMessage(
          UIError(
            uiErrorType: UIErrorType.checkYourInternetConnection,
          ),
        );
      } else if (err.response?.statusCode != 413 &&
          !err.requestOptions.uri.path.contains(startAnswerUrl)) {
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
    }
    return super.onError(err, handler);
  }

  @override
  FutureOr<dynamic> onResponse(
      Response response, ResponseInterceptorHandler handler) async {
    _mainCubit.updateIsLoading(false);
    return super.onResponse(response, handler);
  }
}
