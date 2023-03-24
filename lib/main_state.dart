import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_advisor_interface/infrastructure/brands/base_brand.dart';

part 'main_state.freezed.dart';

@freezed
class MainState with _$MainState {
  const factory MainState({
    @Default(false) bool isLoading,
    @Default(false) bool internetConnectionIsAvailable,
    BaseBrand? currentBrand,
    Locale? locale,
  }) = _MainState;
}
