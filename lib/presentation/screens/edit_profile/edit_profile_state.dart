import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';

part 'edit_profile_state.freezed.dart';

@freezed
class EditProfileState with _$EditProfileState {
  factory EditProfileState([
    @Default('') String imagePath,
    @Default(<XFile>[]) List<XFile> imagesFromGallery,
    @Default(0) int chosenLanguageIndex
  ]) = _EditProfileState;
}
