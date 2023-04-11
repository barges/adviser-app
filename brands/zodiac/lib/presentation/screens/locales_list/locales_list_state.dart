import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zodiac/data/models/user_info/locale_model.dart';

part 'locales_list_state.freezed.dart';

@freezed
class LocalesListState with _$LocalesListState {
  const factory LocalesListState({
   @Default([]) List<LocaleModel> locales,
    String? selectedLocaleCode,
  }) = _LocalesListState;
}