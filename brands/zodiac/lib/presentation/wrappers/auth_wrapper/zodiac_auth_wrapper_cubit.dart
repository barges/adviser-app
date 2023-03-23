import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zodiac/presentation/wrappers/auth_wrapper/zodiac_auth_wrapper_state.dart';
import 'package:zodiac/zodiac.dart';

class ZodiacAuthWrapperCubit extends Cubit<ZodiacAuthWrapperState> {
  ZodiacAuthWrapperCubit() : super(const ZodiacAuthWrapperState()) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      emit(state.copyWith(
        isAuth: ZodiacBrand().isAuth,
        isProcessingData: false,
      ));
    });
  }
}
