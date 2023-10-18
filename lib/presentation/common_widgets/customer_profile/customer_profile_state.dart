import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../data/models/customer_info/customer_info.dart';
import '../../../data/models/customer_info/note.dart';

part 'customer_profile_state.freezed.dart';

@freezed
class CustomerProfileState with _$CustomerProfileState {
  factory CustomerProfileState({
    List<Note>? notes,
    CustomerInfo? customerInfo,
    @Default(false) bool isFavorite,
    @Default(false) bool needRefresh,
  }) = _CustomerProfileState;
}
