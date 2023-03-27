import 'dart:async';

import 'package:shared_advisor_interface/services/fresh_chat_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:zodiac/data/cache/zodiac_caching_manager.dart';
import 'package:zodiac/data/models/user_info/user_info.dart';
import 'package:zodiac/domain/repositories/zodiac_user_repository.dart';
import 'package:zodiac/presentation/screens/support/support_state.dart';

class SupportCubit extends Cubit<SupportState> {
  final ZodiacCachingManager cachingManager;
  final FreshChatService freshChatService;
  final ZodiacUserRepository userRepository;

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

  Future<void> _setUpFreshChat(FreshChaUserInfo? userInfo) async {
    final bool configured =
        await freshChatService.setUpFortunicaFreshChat(userInfo);
    emit(state.copyWith(configured: configured));
  }

  List<String> getCategories() {
    return freshChatService.categoriesByLocale(locale);
  }

  List<String> getContactUsTags() {
    return freshChatService.tagsByLocale(locale);
  }
}
