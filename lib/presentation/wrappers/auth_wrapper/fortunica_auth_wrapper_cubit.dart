/*import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/cache/fortunica_caching_manager.dart';
import '../../../infrastructure/di/inject_config.dart';
import 'fortunica_auth_wrapper_state.dart';

class FortunicaAuthWrapperCubit extends Cubit<FortunicaAuthWrapperState> {
  FortunicaAuthWrapperCubit() : super(const FortunicaAuthWrapperState()) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      emit(state.copyWith(
        isAuth: fortunicaGetIt.get<FortunicaCachingManager>().isAuth,
        isProcessingData: false,
      ));
    });
  }
}*/
