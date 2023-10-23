import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:retrofit/dio.dart';

import '../../../data/cache/caching_manager.dart';
import '../../../domain/repositories/fortunica_auth_repository.dart';
import '../../../infrastructure/routing/app_router.dart';
import '../../../infrastructure/routing/app_router.gr.dart';
import '../../../main_cubit.dart';
import 'drawer_state.dart';

class DrawerCubit extends Cubit<DrawerState> {
  final FortunicaAuthRepository _authRepository;
  final CachingManager _fortunicaCachingManager;
  Timer? _copyTimer;

  DrawerCubit(
    this._authRepository,
    this._fortunicaCachingManager,
  ) : super(const DrawerState()) {
    getVersion();
  }

  @override
  Future<void> close() async {
    _copyTimer?.cancel();
    return super.close();
  }

  // Future<void> openSettingsUrl() async {
  //   final Uri url = Uri.parse(AppConstants.webToolUrl);
  //   if (!await launchUrl(
  //     url,
  //     mode: LaunchMode.externalApplication,
  //   )) {
  //     Get.showSnackbar(GetSnackBar(
  //       duration: const Duration(seconds: 2),
  //       message: 'Could not launch $url',
  //     ));
  //   }
  // }

  void getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    String build = packageInfo.buildNumber;
    emit(state.copyWith(version: '$version ($build)'));
  }

  void tapToCopy() async {
    await Clipboard.setData(ClipboardData(text: state.version ?? ''));
    if (_copyTimer == null || _copyTimer?.isActive == false) {
      emit(state.copyWith(copyButtonTapped: true));
      _copyTimer = Timer(const Duration(seconds: 2), () {
        emit(state.copyWith(copyButtonTapped: false));
      });
    }
  }

  Future<void> logout(BuildContext context) async {
    final HttpResponse response = await _authRepository.logout();
    if (response.response.statusCode == 200) {
      await _fortunicaCachingManager.logout();
      if (context.mounted) {
        context.read<MainCubit>().updateAuth(false);
        context.replaceAll([const FortunicaLogin()]);
      }
    }
  }
}
