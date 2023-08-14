import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zodiac/data/models/services/image_sample_model.dart';

part 'edit_service_state.freezed.dart';

@freezed
class EditServiceState with _$EditServiceState {
  const factory EditServiceState({
    @Default(false) bool alreadyFetchData,
    List<ImageSampleModel>? images,
    @Default(false) bool updateTextsFlag,
    @Default(0) int selectedLanguageIndex,
    int? mainLanguageIndex,
    List<String>? languagesList,
  }) = _EditServiceState;
}
