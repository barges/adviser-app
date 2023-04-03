import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/data/cache/caching_manager.dart';
import 'package:shared_advisor_interface/data/models/enums/markets_type.dart';
import 'package:shared_advisor_interface/data/models/user_info/localized_properties/property_by_language.dart';
import 'package:shared_advisor_interface/data/models/user_info/user_profile.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/resources/app_arguments.dart';
import 'package:shared_advisor_interface/presentation/screens/advisor_preview/advisor_preview_state.dart';
import 'package:shared_advisor_interface/presentation/screens/advisor_preview/advisor_preview_constants.dart';

class AdvisorPreviewCubit extends Cubit<AdvisorPreviewState> {
  final CachingManager cacheManager = getIt.get<CachingManager>();
  final MainCubit mainCubit;
  late UserProfile userProfile;
  late List<MarketsType> languages;
  late bool needRefresh;

  VoidCallback? _listenUserProfile;

  AdvisorPreviewCubit(this.mainCubit) : super(AdvisorPreviewState()) {
    AdvisorPreviewScreenArguments arguments =
        Get.arguments as AdvisorPreviewScreenArguments;
    needRefresh = arguments.isAccountTimeout;

    userProfile = cacheManager.getUserProfile() ?? const UserProfile();
    languages = userProfile.activeLanguages ?? const [];
    _listenUserProfile = cacheManager.listenUserProfile((value) {
      userProfile = value;
      languages = userProfile.activeLanguages ?? const [];
      emit(state.copyWith(updateInfo: !state.updateInfo));
    });
  }

  @override
  Future<void> close() async {
    _listenUserProfile?.call();
    return super.close();
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
