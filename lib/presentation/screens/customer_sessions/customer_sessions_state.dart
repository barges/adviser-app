import 'package:freezed_annotation/freezed_annotation.dart';

part 'customer_sessions_state.freezed.dart';

@freezed
class CustomerSessionsState with _$CustomerSessionsState {
  const factory CustomerSessionsState([
    @Default(0) int currentFilterIndex,
  ]) = _CustomerSessionsState;
}
