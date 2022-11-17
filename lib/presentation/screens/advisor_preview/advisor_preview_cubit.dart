import 'package:bloc/bloc.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/data/cache/caching_manager.dart';
import 'package:shared_advisor_interface/data/models/enums/markets_type.dart';
import 'package:shared_advisor_interface/data/models/user_info/localized_properties/property_by_language.dart';
import 'package:shared_advisor_interface/data/models/user_info/user_profile.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/presentation/screens/advisor_preview/advisor_preview_state.dart';
import 'package:shared_advisor_interface/presentation/screens/advisor_preview/constants.dart';

class AdvisorPreviewCubit extends Cubit<AdvisorPreviewState> {
  final CachingManager cacheManager = getIt.get<CachingManager>();
  late final UserProfile userProfile;
  late final List<MarketsType> languages;

  AdvisorPreviewCubit() : super(AdvisorPreviewState()) {
    userProfile = cacheManager.getUserProfile() ?? const UserProfile();
    languages = userProfile.activeLanguages ?? const [];
  }

  void updateActiveLanguagesInUI(int index) {
    emit(state.copyWith(oldIndex: index));
  }

  void onApply() {
    emit(state.copyWith(currentIndex: state.oldIndex));
    Get.back();
  }

  void onOpen() {
    emit(state.copyWith(oldIndex: state.currentIndex));
  }

  Map<String, dynamic> getSelectedLanguageDetails(MarketsType language) {
    Map<String, dynamic> details = {};
    details[ratingKey] = userProfile.rating?[language] as double;
    details[titleKey] = (userProfile.localizedProperties
                ?.toJson()[language.name] as PropertyByLanguage?)
            ?.statusMessage ??
        '';
    details[descriptionKey] = (userProfile.localizedProperties
                ?.toJson()[language.name] as PropertyByLanguage?)
            ?.description ??
        '';
    return details;
  }
}
