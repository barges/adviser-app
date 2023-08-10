import 'package:freezed_annotation/freezed_annotation.dart';

part 'coupons_state.freezed.dart';

@freezed
class CouponsState with _$CouponsState {
  const factory CouponsState({
    @Default(0) int selectedCategoryIndex,
    @Default(1) int selectedCouponIndex,
    String? errorMessage,
  }) = _CouponsState;
}
