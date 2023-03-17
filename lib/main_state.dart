import 'package:shared_advisor_interface/configuration.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'main_state.freezed.dart';

@freezed
class MainState with _$MainState {
  const factory MainState({
    @Default(false) bool isLoading,
    @Default(false) bool internetConnectionIsAvailable,
    @Default(Brand.fortunica) Brand currentBrand,
    Locale? locale,
  }) = _MainState;
}
