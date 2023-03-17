import 'package:shared_advisor_interface/configuration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortunica/presentation/wrappers/auth_wrapper/fortunica_auth_wrapper_state.dart';

class FortunicaAuthWrapperCubit extends Cubit<FortunicaAuthWrapperState> {

  FortunicaAuthWrapperCubit() : super(const FortunicaAuthWrapperState()) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      emit(state.copyWith(
        isAuth: Brand.fortunica.isAuth,
        isProcessingData: false,
      ));
    });

  }
  }
