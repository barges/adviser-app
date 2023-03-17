import 'dart:async';

import 'package:shared_advisor_interface/configuration.dart';
import 'package:shared_advisor_interface/data/cache/global_caching_manager.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:shared_advisor_interface/presentation/screens/drawer/drawer_state.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:retrofit/dio.dart';

class DrawerCubit extends Cubit<DrawerState> {
  final GlobalCachingManager _cacheManager;

  late final List<Brand> authorizedBrands;
  late final List<Brand> unauthorizedBrands;

  Timer? _copyTimer;

  DrawerCubit(
    this._cacheManager,
  ) : super(const DrawerState()) {
    getVersion();
    authorizedBrands =
        Configuration.authorizedBrands(_cacheManager.getCurrentBrand())
            .reversed
            .toList();
    unauthorizedBrands = Configuration.unauthorizedBrands();
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
    await Clipboard.setData(ClipboardData(text: state.version));
    if (_copyTimer == null || _copyTimer?.isActive == false) {
      emit(state.copyWith(copyButtonTapped: true));
      _copyTimer = Timer(const Duration(seconds: 2), () {
        emit(state.copyWith(copyButtonTapped: false));
      });
    }
  }
}
