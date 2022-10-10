import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/data/cache/cache_manager.dart';
import 'package:shared_advisor_interface/data/models/enums/fortunica_user_status.dart';
import 'package:shared_advisor_interface/data/models/localized_properties/property_by_language.dart';
import 'package:shared_advisor_interface/data/models/user_info/user_info.dart';
import 'package:shared_advisor_interface/data/network/requests/push_enable_request.dart';
import 'package:shared_advisor_interface/data/network/requests/update_user_status_request.dart';
import 'package:shared_advisor_interface/domain/repositories/user_repository.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/resources/app_routes.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/account/account_state.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountCubit extends Cubit<AccountState> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  final TextEditingController commentController = TextEditingController();

  final UserRepository userRepository = Get.find<UserRepository>();

  final CacheManager cacheManager;

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
    try {
      int seconds = 0;

      final UserInfo userInfo = info ?? await run(userRepository.getUserInfo());

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
    } catch (e) {
      ///TODO: Handle the error
      rethrow;
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
    try {
      final UserInfo userInfo =
          await run(userRepository.updateUserStatus(request));
      refreshUserinfo(
        info: userInfo,
      );
    } catch (e) {
      ///TODO: Handle the error
      rethrow;
    }
  }

  Future<void> updateEnableNotificationsValue(bool newValue) async {
    try {
      final UserInfo userInfo = await run(
          userRepository.setPushEnabled(PushEnableRequest(value: newValue)));
      emit(
        state.copyWith(
          enableNotifications: userInfo.pushNotificationsEnabled ?? false,
        ),
      );
    } catch (e) {
      ///TODO: Handle the error
      rethrow;
    }
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
