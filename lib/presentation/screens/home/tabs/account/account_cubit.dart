import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/data/cache/cache_manager.dart';
import 'package:shared_advisor_interface/data/models/enums/fortunica_user_status.dart';
import 'package:shared_advisor_interface/data/models/localized_properties/property_by_language.dart';
import 'package:shared_advisor_interface/data/models/user_info/user_info.dart';
import 'package:shared_advisor_interface/data/network/requests/push_enable_request.dart';
import 'package:shared_advisor_interface/domain/repositories/user_repository.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/account/account_state.dart';

class AccountCubit extends Cubit<AccountState> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  final TextEditingController searchController = TextEditingController();

  final UserRepository userRepository = Get.find<UserRepository>();

  final CacheManager cacheManager;
  late final VoidCallback disposeListen;

  AccountCubit(this.cacheManager) : super(const AccountState()) {
    disposeListen = cacheManager.listenUserProfile((value) {
      emit(state.copyWith(userProfile: value));
    });
    getUserinfo();
  }

  Future<void> getUserinfo() async {
    try {
      final UserInfo userInfo = await userRepository.getUserInfo();

      await cacheManager.saveUserProfile(userInfo.profile);
      await cacheManager.saveUserId(userInfo.id);

      if (checkPropertiesMap(userInfo)) {
        await cacheManager.saveUserStatus(userInfo.status?.copyWith(
          status: FortunicaUserStatusEnum.incomplete,
        ));
      } else {
        await cacheManager.saveUserStatus(userInfo.status);
      }
      emit(
        state.copyWith(
          userProfile: userInfo.profile,
          enableNotifications: userInfo.pushNotificationsEnabled ?? false,
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

  void updateUserStatus(bool newValue) {
    emit(state.copyWith(isAvailable: newValue));
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
}
