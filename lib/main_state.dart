import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'data/models/app_error/app_error.dart';

part 'main_state.freezed.dart';

@freezed
class MainState with _$MainState {
  const factory MainState({
    @Default(false) bool isLoading,
    @Default(false) bool internetConnectionIsAvailable,
    Locale? locale,
    @Default(EmptyError()) AppError appError,
    @Default(false) bool isAuth,
  }) = _MainState;
}
