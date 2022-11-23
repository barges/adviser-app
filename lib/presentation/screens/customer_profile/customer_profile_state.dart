import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_advisor_interface/data/models/customer_info/customer_info.dart';
import 'package:shared_advisor_interface/data/network/responses/get_note_response.dart';

part 'customer_profile_state.freezed.dart';

@freezed
class CustomerProfileState with _$CustomerProfileState {
  factory CustomerProfileState(
      {GetNoteResponse? currentNote,
      CustomerInfo? customerInfo,
      @Default(false) bool isFavorite}) = _CustomerProfileState;
}
