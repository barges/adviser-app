import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_advisor_interface/data/network/responses/customer_info_response/customer_info_response.dart';
import 'package:shared_advisor_interface/data/network/responses/get_note_response.dart';

part 'user_profile_state.freezed.dart';

@freezed
class UserProfileState with _$UserProfileState {
  factory UserProfileState(
      {@Default(null) String? currentNote,
      @Default(null) String? createdNoteTime,
      @Default(null) CustomerInfoResponse? response,
      @Default(false) bool isFavorite}) = _UserProfileState;
}
