import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/data/cache/caching_manager.dart';
import 'package:shared_advisor_interface/data/models/user_info/fortunica_user_status.dart';
import 'package:shared_advisor_interface/data/models/user_info/localized_properties/property_by_language.dart';
import 'package:shared_advisor_interface/data/models/user_info/user_info.dart';
import 'package:shared_advisor_interface/data/network/requests/push_enable_request.dart';
import 'package:shared_advisor_interface/data/network/requests/update_user_status_request.dart';
import 'package:shared_advisor_interface/domain/repositories/user_repository.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/resources/app_routes.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/account/account_state.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountCubit extends Cubit<AccountState> {
  final TextEditingController commentController = TextEditingController();

  final MainCubit mainCubit = Get.find<MainCubit>();

  final UserRepository _userRepository = Get.find<UserRepository>();

  final CachingManager cacheManager;

  final Uri _url = Uri.parse(AppConstants.webToolUrl);

  late final VoidCallback disposeListen;

  AccountCubit(this.cacheManager) : super(const AccountState()) {
    disposeListen = cacheManager.listenUserProfile((value) {
      emit(state.copyWith(userProfile: value));
    });
    commentController.addListener(() {
      emit(
        state.copyWith(
          commentButtonIsActive: commentController.text.isNotEmpty,
        ),
      );
    });
    refreshUserinfo();
  }

  @override
  Future<void> close() async {
    disposeListen.call();
    commentController.dispose();
    return super.close();
  }

  Future<void> refreshUserinfo({UserInfo? info}) async {
    if (mainCubit.state.internetConnectionIsAvailable) {
      int seconds = 0;

      final UserInfo userInfo = info ?? await _userRepository.getUserInfo();

      await cacheManager.saveUserInfo(userInfo);
      await cacheManager.saveUserProfile(userInfo.profile);
      await cacheManager.saveUserId(userInfo.id);

      if (checkPropertiesMap(userInfo)) {
        await cacheManager.saveUserStatus(userInfo.status?.copyWith(
          status: FortunicaUserStatusEnum.incomplete,
        ));
      } else {
        await cacheManager.saveUserStatus(userInfo.status);
      }
      final DateTime? profileUpdatedAt =
          cacheManager.getUserStatus()?.profileUpdatedAt;

      if (profileUpdatedAt != null) {
        seconds = DateTime.now().difference(profileUpdatedAt).inSeconds;
      }

      emit(
        state.copyWith(
          userProfile: cacheManager.getUserProfile(),
          enableNotifications: userInfo.pushNotificationsEnabled ?? false,
          seconds: seconds > 0 ? AppConstants.secondsInHour - seconds : seconds,
        ),
      );
    }
  }

  bool checkPropertiesMap(UserInfo userInfo) {
    final Map<String, dynamic> propertiesMap =
        userInfo.profile?.localizedProperties?.toJson() ?? {};

    if (propertiesMap.isNotEmpty) {
      for (String languageCode in userInfo.profile?.activeLanguages ?? []) {
        final PropertyByLanguage property = propertiesMap[languageCode];
        if (property.statusMessage?.isEmpty == true ||
            property.description?.isEmpty == true) {
          return true;
        }
      }
    }
    return false;
  }

  Future<void> updateUserStatus(
      {required FortunicaUserStatusEnum status}) async {
    final UpdateUserStatusRequest request = UpdateUserStatusRequest(
      status: status,
      comment: commentController.text,
    );
    final UserInfo userInfo = await _userRepository.updateUserStatus(request);
    refreshUserinfo(
      info: userInfo,
    );
  }

  Future<void> updateEnableNotificationsValue(bool newValue) async {
    final UserInfo userInfo =
        await _userRepository.setPushEnabled(PushEnableRequest(value: newValue));
    emit(
      state.copyWith(
        enableNotifications: userInfo.pushNotificationsEnabled ?? false,
      ),
    );
  }

  Future<void> goToEditProfile() async {
    final dynamic needUpdateInfo = await Get.toNamed(
      AppRoutes.editProfile,
    );
    if (needUpdateInfo is bool && needUpdateInfo == true) {
      refreshUserinfo();
    }
  }

  void hideTimer() {
    emit(
      state.copyWith(
        seconds: 0,
      ),
    );
  }

  Future<void> openSettingsUrl() async {
    if (!await launchUrl(
      _url,
      mode: LaunchMode.externalApplication,
    )) {
      Get.showSnackbar(GetSnackBar(
        duration: const Duration(seconds: 2),
        message: 'Could not launch $_url',
      ));
    }
  }
}
