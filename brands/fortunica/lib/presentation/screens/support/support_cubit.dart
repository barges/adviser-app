import 'dart:async';

import 'package:collection/collection.dart';
import 'package:shared_advisor_interface/services/fresh_chat_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortunica/data/cache/fortunica_caching_manager.dart';
import 'package:fortunica/data/models/user_info/user_info.dart';
import 'package:fortunica/data/network/requests/restore_freshchat_id_request.dart';
import 'package:fortunica/domain/repositories/fortunica_user_repository.dart';
import 'package:fortunica/presentation/screens/support/support_state.dart';
import 'package:intl/intl.dart';

class SupportCubit extends Cubit<SupportState> {
  final FortunicaCachingManager cachingManager;
  final FreshChatService freshChatService;
  final FortunicaUserRepository userRepository;

  StreamSubscription? _restoreSubscription;

  late final String locale;

  SupportCubit({
    required this.cachingManager,
    required this.freshChatService,
    required this.userRepository,
  }) : super(const SupportState()) {
    locale = Intl.getCurrentLocale();
    final UserInfo? userInfo = cachingManager.getUserInfo();

    _setUpFreshChat(userInfo);

    if (userInfo?.freshchatInfo?.restoreId == null) {
      _restoreSubscription =
          freshChatService.onRestoreStream().listen((event) async {
        final String? restoreId = await freshChatService.getRestoreId();
        if (restoreId != null) {
          userRepository.setFreshchatRestoreId(
            RestoreFreshchatIdRequest(
              restoreId: restoreId,
            ),
          );
        }
      });
    }
  }

  @override
  Future<void> close() {
    _restoreSubscription?.cancel();
    return super.close();
  }

  Future<void> _setUpFreshChat(UserInfo? userInfo) async {
    final FreshChaUserInfo freshChaUserInfo = FreshChaUserInfo(
      userId: userInfo?.id,
      restoreId: userInfo?.freshchatInfo?.restoreId,
      email: userInfo?.emails?.firstOrNull?.address,
      profileName: userInfo?.profile?.profileName,
    );

    final bool configured =
        await freshChatService.setUpFortunicaFreshChat(freshChaUserInfo);
    emit(state.copyWith(configured: configured));
  }
}
