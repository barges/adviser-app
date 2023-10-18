import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../data/cache/fortunica_caching_manager.dart';
import '../../../data/models/user_info/user_info.dart';
import '../../../data/network/requests/restore_freshchat_id_request.dart';
import '../../../domain/repositories/fortunica_user_repository.dart';
import '../../../services/fresh_chat_service.dart';
import 'support_state.dart';

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
        await freshChatService.setUpFreshChat(freshChaUserInfo);
    emit(state.copyWith(configured: configured));
  }

  List<String> freshChatTags(String languageCode) {
    List<String> tags = [
      'foen',
    ];
    switch (languageCode) {
      case 'de':
        tags = [
          'fode',
        ];
        break;

      case 'es':
        tags = [
          'foes',
        ];
        break;
      case 'pt':
        tags = [
          'fopt',
        ];
        break;
      case 'en':
      default:
    }
    return tags;
  }

  List<String> freshChatCategories(String languageCode) {
    List<String> categories = [
      'general_foen_advisor',
      'payments_foen_advisor',
      'offers_foen_advisor',
      'tips_foen_advisor',
      'techhelp_foen_advisor',
      'performance_foen_advisor',
      'webtool_foen_advisor',
    ];
    switch (languageCode) {
      case 'de':
        categories = [
          'general_fode_advisor',
          'payments_fode_advisor',
          'offers_fode_advisor',
          'tips_fode_advisor',
          'techhelp_fode_advisor',
          'performance_fode_advisor',
        ];
        break;

      case 'es':
        categories = [
          'general_foes_advisor',
          'payments_foes_advisor',
          'webtool_foes_advisor',
          'tips_foes_advisor',
          'performance_foes_advisor',
          'specialcases_foes_advisor',
        ];
        break;
      case 'pt':
        categories = [
          'general_fopt_advisor',
          'payments_fopt_advisor',
          'offers_fopt_advisor',
          'tips_fopt_advisor',
          'techhelp_fopt_advisor',
        ];
        break;
      case 'en':
      default:
    }
    return categories;
  }
}
