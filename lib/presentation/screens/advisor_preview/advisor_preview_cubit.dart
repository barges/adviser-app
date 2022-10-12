import 'package:bloc/bloc.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/data/cache/cache_manager.dart';
import 'package:shared_advisor_interface/data/models/localized_properties/property_by_language.dart';
import 'package:shared_advisor_interface/data/models/user_info/user_profile.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/presentation/screens/advisor_preview/advisor_preview_state.dart';
import 'package:shared_advisor_interface/presentation/screens/advisor_preview/constants.dart';

class AdvisorPreviewCubit extends Cubit<AdvisorPreviewState> {
  final CacheManager cacheManager = Get.find<CacheManager>();
  late final UserProfile userProfile;
  late final List<String> languages;

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

  void onCancel() {
    emit(state.copyWith(oldIndex: state.currentIndex));
    Get.back();
  }

  Map<String, dynamic> getSelectedLanguageDetails(String language) {
    Map<String, dynamic> details = {};
    details[ratingKey] = userProfile.rating?.toJson()[language] as double;
    details[titleKey] = userProfile.rituals?.firstOrNull ?? '';
    details[descriptionKey] = (userProfile.localizedProperties
                ?.toJson()[language] as PropertyByLanguage?)
            ?.description ??
        '';
    return details;
  }
}
