import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/data/cache/caching_manager.dart';
import 'package:shared_advisor_interface/data/models/user_info/user_info.dart';
import 'package:shared_advisor_interface/data/network/requests/restore_freshchat_id_request.dart';
import 'package:shared_advisor_interface/domain/repositories/user_repository.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/screens/support/support_state.dart';
import 'package:shared_advisor_interface/presentation/services/fresh_chat_service.dart';

class SupportCubit extends Cubit<SupportState> {
  final CachingManager _cachingManager;
  final FreshChatService _freshChatService = Get.find<FreshChatService>();
  final UserRepository _userRepository = Get.find<UserRepository>();

  StreamSubscription? _restoreSubscription;

  late final Locale locale;

  SupportCubit(this._cachingManager) : super(const SupportState()) {
    locale = S.delegate.supportedLocales[_cachingManager.getLocaleIndex() ?? 0];
    final UserInfo? userInfo = _cachingManager.getUserInfo();
    if (userInfo != null) {
      _setUpFreshChat(userInfo);

      if (userInfo.freshchatInfo?.restoreId == null) {
        _restoreSubscription =
            _freshChatService.onRestoreStream().listen((event) async {
          final String? restoreId = await _freshChatService.getRestoreId();
          if (restoreId != null) {
            _userRepository.setFreshchatRestoreId(
              RestoreFreshchatIdRequest(
                restoreId: restoreId,
              ),
            );
          }
        });
      }
    }
  }

  @override
  Future<void> close() {
    _restoreSubscription?.cancel();
    return super.close();
  }

  Future<void> _setUpFreshChat(UserInfo userInfo) async {
    final bool configured = await _freshChatService.setUpFreshChat(userInfo);
    emit(state.copyWith(configured: configured));
  }

  List<String> getCategories() {
    return _freshChatService.categoriesByLocale(locale.languageCode);
  }

  List<String> getContactUsTags() {
    return _freshChatService.tagsByLocale(locale.languageCode);
  }
}
