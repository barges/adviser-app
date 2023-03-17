import 'package:freezed_annotation/freezed_annotation.dart';

part 'support_state.freezed.dart';

@freezed
class SupportState with _$SupportState {
  const factory SupportState({
    @Default(false) bool configured,
  }) = _SupportState;
}
