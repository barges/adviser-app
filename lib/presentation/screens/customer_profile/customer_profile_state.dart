import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_advisor_interface/data/network/responses/customer_info_response/customer_info_response.dart';
import 'package:shared_advisor_interface/data/network/responses/get_note_response.dart';

part 'customer_profile_state.freezed.dart';

@freezed
class CustomerProfileState with _$CustomerProfileState {
  factory CustomerProfileState(
      {@Default(null) GetNoteResponse? currentNote,
      @Default(null) CustomerInfoResponse? response,
      @Default(false) bool isFavorite}) = _CustomerProfileState;
}
