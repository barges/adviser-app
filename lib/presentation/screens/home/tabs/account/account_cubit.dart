import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/data/cache/caching_manager.dart';
import 'package:shared_advisor_interface/data/models/enums/fortunica_user_status.dart';
import 'package:shared_advisor_interface/data/models/enums/markets_type.dart';
import 'package:shared_advisor_interface/data/models/user_info/localized_properties/property_by_language.dart';
import 'package:shared_advisor_interface/data/models/user_info/user_info.dart';
import 'package:shared_advisor_interface/data/network/requests/push_enable_request.dart';
import 'package:shared_advisor_interface/data/network/requests/update_user_status_request.dart';
import 'package:shared_advisor_interface/domain/repositories/user_repository.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/resources/app_routes.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/account/account_state.dart';
import 'package:shared_advisor_interface/presentation/services/connectivity_service.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountCubit extends Cubit<AccountState> {
  final TextEditingController commentController = TextEditingController();
  final FocusNode commentNode = FocusNode();

  final MainCubit mainCubit;

  final UserRepository _userRepository;
  final ConnectivityService _connectivityService;

  final CachingManager cacheManager;

  final Uri _url = Uri.parse(AppConstants.webToolUrl);

  late final VoidCallback disposeListen;

  AccountCubit(
    this.cacheManager,
    this.mainCubit,
    this._userRepository,
    this._connectivityService,
  ) : super(const AccountState()) {
    disposeListen = cacheManager.listenUserProfile((value) {
      emit(state.copyWith(userProfile: value));
    });

    commentNode.addListener(() {
      emit(state.copyWith(commentHasFocus: commentNode.hasFocus));
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
    commentNode.dispose();
    return super.close();
  }

  Future<void> refreshUserinfo() async {
    if (await _connectivityService.checkConnection()) {
      int milliseconds = 0;

      final UserInfo userInfo = await _userRepository.getUserInfo();

      await cacheManager.saveUserInfo(userInfo);
      await cacheManager.saveUserProfile(userInfo.profile);
      await cacheManager.saveUserId(userInfo.id);

      if (userInfo.contracts?.updates?.isNotEmpty == true) {
        await cacheManager.saveUserStatus(userInfo.status?.copyWith(
          status: FortunicaUserStatus.legalBlock,
        ));
      } else {
        if (checkPropertiesMapIfHasEmpty(userInfo) ||
            userInfo.profile?.profileName?.isNotEmpty != true ||
            userInfo.profile?.profilePictures?.isNotEmpty != true) {
          await cacheManager.saveUserStatus(userInfo.status?.copyWith(
            status: FortunicaUserStatus.incomplete,
          ));
        } else {
          await cacheManager.saveUserStatus(userInfo.status);
        }
      }

      final DateTime? profileUpdatedAt =
          cacheManager.getUserStatus()?.profileUpdatedAt;

      if (profileUpdatedAt != null) {
        DateTime currentTime = DateTime.now().toUtc();
        currentTime = currentTime.add(const Duration(seconds: 15));
        milliseconds = currentTime.difference(profileUpdatedAt).inMilliseconds;
      }

      emit(
        state.copyWith(
          userProfile: cacheManager.getUserProfile(),
          enableNotifications: userInfo.pushNotificationsEnabled ?? false,
          millisecondsForTimer: milliseconds > 0
              ? AppConstants.millisecondsInHour - milliseconds
              : milliseconds,
        ),
      );
    }
  }

  bool checkPropertiesMapIfHasEmpty(UserInfo userInfo) {
    final Map<String, dynamic> propertiesMap =
        userInfo.profile?.localizedProperties?.toJson() ?? {};

    if (propertiesMap.isNotEmpty) {
      for (MarketsType marketsType in userInfo.profile?.activeLanguages ?? []) {
        final PropertyByLanguage property = propertiesMap[marketsType.name];
        if (property.statusMessage?.trim().isEmpty == true ||
            property.description?.trim().isEmpty == true) {
          return true;
        }
      }
    }
    return false;
  }

  Future<void> updateUserStatus({required FortunicaUserStatus status}) async {
    final UpdateUserStatusRequest request = UpdateUserStatusRequest(
      status: status,
      comment: commentController.text,
    );
    await _userRepository.updateUserStatus(request);
    refreshUserinfo();
  }

  Future<void> updateEnableNotificationsValue(bool newValue) async {
    final UserInfo userInfo = await _userRepository
        .setPushEnabled(PushEnableRequest(value: newValue));
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
        millisecondsForTimer: 0,
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
