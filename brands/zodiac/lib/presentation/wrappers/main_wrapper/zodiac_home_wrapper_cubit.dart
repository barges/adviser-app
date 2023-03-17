import 'package:shared_advisor_interface/configuration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zodiac/presentation/wrappers/main_wrapper/zodiac_home_wrapper_state.dart';

class ZodiacHomeWrapperCubit extends Cubit<ZodiacHomeWrapperState> {

  ZodiacHomeWrapperCubit() : super(const ZodiacHomeWrapperState()) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      emit(state.copyWith(
        isAuth: Brand.zodiac.isAuth,
        isProcessingData: false,
      ));
    });
  }
}