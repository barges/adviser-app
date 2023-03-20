import 'dart:async';

import 'package:shared_advisor_interface/configuration.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.gr.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/force_update/force_update_screen.dart';
import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:fortunica/data/cache/fortunica_caching_manager.dart';
import 'package:shared_advisor_interface/data/models/app_error/app_error.dart';
import 'package:fortunica/data/models/app_errors/app_error.dart';
import 'package:fortunica/data/models/app_errors/ui_error_type.dart';
import 'package:fortunica/data/network/api/chats_api.dart';
import 'package:fortunica/fortunica_main_cubit.dart';
import 'package:fortunica/infrastructure/routing/route_paths_fortunica.dart';
import 'package:fortunica/presentation/screens/home/tabs_types.dart';
import 'package:injectable/injectable.dart';

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
  final FortunicaMainCubit _fortunicaMainCubit;
  final FortunicaCachingManager _cachingManager;

  AppInterceptor(
      this._mainCubit, this._fortunicaMainCubit, this._cachingManager);

  @override
  FutureOr<dynamic> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    _fortunicaMainCubit.clearErrorMessage();
    _mainCubit.updateIsLoading(true);
    return super.onRequest(options, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    final BuildContext? fortunicaContext = Configuration.fortunicaContext;

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
        ///TODO: Maybe do not work! Need check!
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
            fortunicaContext.replaceAll([FortunicaAuth()]);
            _fortunicaMainCubit.updateErrorMessage(
              UIError(uiErrorType: UIErrorType.blocked),
            );
          });
        } else {
          _fortunicaMainCubit.updateErrorMessage(
            UIError(
              uiErrorType: UIErrorType.wrongUsernameAndOrPassword,
            ),
          );
        }
      } else if (err.response?.statusCode == 400 && isLogin) {
        _fortunicaMainCubit.updateErrorMessage(
          UIError(uiErrorType: UIErrorType.blocked),
        );
      } else if (err.response?.statusCode == 451 ||
          err.response?.statusCode == 428) {
        fortunicaContext.replaceAll(
          [
            FortunicaAuth(),
          ],
        );
      } else if (err.type == DioErrorType.connectTimeout ||
          err.type == DioErrorType.receiveTimeout ||
          err.type == DioErrorType.sendTimeout ||
          err.type == DioErrorType.other) {
        _fortunicaMainCubit.updateErrorMessage(
          UIError(
            uiErrorType: UIErrorType.checkYourInternetConnection,
          ),
        );
      } else if (err.response?.statusCode != 413 &&
          !err.requestOptions.uri.path.contains(startAnswerUrl)) {
        try {
          _fortunicaMainCubit.updateErrorMessage(
            NetworkError(
              message: err.response?.data[_localizedMessageKey] ??
                  err.response?.data[_messageKey] ??
                  err.response?.data[_statusKey],
            ),
          );
        } catch (e) {
          _fortunicaMainCubit.updateErrorMessage(
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
