import 'package:freezed_annotation/freezed_annotation.dart';

part 'coupons_state.freezed.dart';

@freezed
class CouponsState with _$CouponsState {
  const factory CouponsState({
    @Default(0) int selectedCategoryIndex,
    String? errorMessage,
  }) = _CouponsState;
}
