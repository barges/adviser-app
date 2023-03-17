import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortunica/data/cache/fortunica_caching_manager.dart';
import 'package:fortunica/data/models/enums/markets_type.dart';
import 'package:fortunica/data/models/user_info/localized_properties/property_by_language.dart';
import 'package:fortunica/data/models/user_info/user_profile.dart';
import 'package:fortunica/fortunica_main_cubit.dart';
import 'package:fortunica/infrastructure/di/inject_config.dart';
import 'package:fortunica/presentation/screens/advisor_preview/advisor_preview_constants.dart';
import 'package:fortunica/presentation/screens/advisor_preview/advisor_preview_state.dart';

class AdvisorPreviewCubit extends Cubit<AdvisorPreviewState> {
  final FortunicaCachingManager cacheManager =
      fortunicaGetIt.get<FortunicaCachingManager>();
  final FortunicaMainCubit mainCubit;
  late UserProfile userProfile;
  late List<MarketsType> languages;

  late final StreamSubscription _userProfileSubscription;

  AdvisorPreviewCubit(
    this.mainCubit,
  ) : super(AdvisorPreviewState()) {
    userProfile = cacheManager.getUserProfile() ?? const UserProfile();
    languages = userProfile.activeLanguages ?? const [];
    _userProfileSubscription = cacheManager.listenUserProfileStream((value) {
      userProfile = value;
      languages = userProfile.activeLanguages ?? const [];
      emit(state.copyWith(updateInfo: !state.updateInfo));
    });
  }

  @override
  Future<void> close() async {
    _userProfileSubscription.cancel();
    return super.close();
  }

  void updateActiveLanguagesInUI(int index) {
    emit(state.copyWith(oldIndex: index));
  }

  void onApply() {
    emit(state.copyWith(currentIndex: state.oldIndex));
  }

  void onOpen() {
    emit(state.copyWith(oldIndex: state.currentIndex));
  }

  Map<String, dynamic> getSelectedLanguageDetails(MarketsType language) {
    Map<String, dynamic> details = {};
    details[AdvisorPreviewConstants.ratingKey] = userProfile.rating?[language];
    details[AdvisorPreviewConstants.titleKey] = (userProfile.localizedProperties
                ?.toJson()[language.name] as PropertyByLanguage?)
            ?.statusMessage ??
        '';
    details[AdvisorPreviewConstants.descriptionKey] =
        (userProfile.localizedProperties?.toJson()[language.name]
                    as PropertyByLanguage?)
                ?.description ??
            '';
    return details;
  }

  Future<void> refreshInfo() async {
    mainCubit.updateAccount();
  }

  void closeErrorWidget() {
    mainCubit.clearErrorMessage();
  }
}
