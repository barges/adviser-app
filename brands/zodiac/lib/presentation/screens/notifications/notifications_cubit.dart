import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.gr.dart';
import 'package:shared_advisor_interface/services/connectivity_service.dart';
import 'package:zodiac/data/models/notification/notification_item.dart';
import 'package:zodiac/data/network/requests/notifications_request.dart';
import 'package:zodiac/data/network/responses/notifications_response.dart';
import 'package:zodiac/domain/repositories/zodiac_user_repository.dart';
import 'package:zodiac/presentation/screens/notifications/notifications_state.dart';
import 'package:zodiac/zodiac_main_cubit.dart';

const int _count = 20;

class NotificationsCubit extends Cubit<NotificationsState> {
  final ZodiacUserRepository _userRepository;
  final ZodiacMainCubit _zodiacMainCubit;
  final ConnectivityService _connectivityService;

  final ScrollController scrollController = ScrollController();

  late final StreamSubscription<bool> _updateNotificationsListSubscription;

  bool _isLoading = false;
  bool _hasMore = true;
  List<NotificationItem> _notificationsList = [];

  NotificationsCubit(this._userRepository, this._zodiacMainCubit,
      this._connectivityService, double screenHeight)
      : super(const NotificationsState()) {
    _getFirstNotifications();

    scrollController.addListener(() {
      if (!_isLoading &&
          scrollController.position.extentAfter <= screenHeight) {
        getNotifications();
      }
    });

    _updateNotificationsListSubscription =
        _zodiacMainCubit.updateNotificationsListTrigger.listen((value) {
      getNotifications(refresh: true);
    });
  }

  @override
  Future<void> close() async {
    _updateNotificationsListSubscription.cancel();
    super.close();
  }

  Future<void> _getFirstNotifications() async {
    await getNotifications();
    _zodiacMainCubit.updateUnreadNotificationsCounter();
  }

  Future<void> getNotifications({bool refresh = false}) async {
    try {
      _isLoading = true;
      if (await _connectivityService.checkConnection()) {
        if (refresh) {
          _notificationsList.clear();
          _hasMore = true;
        }
        if (_hasMore) {
          NotificationsResponse response =
              await _userRepository.getNotificationsList(
            NotificationsRequest(
              count: _count,
              offset: _notificationsList.length,
              fromScreen: true,
            ),
          );
          if (response.errorCode == 0) {
            _notificationsList.addAll(response.result ?? []);
            _hasMore = response.count != null &&
                _notificationsList.length < response.count!;
            emit(state.copyWith(notifications: List.of(_notificationsList)));
          }
        }
      }
    } catch (e) {
      logger.d(e);
    } finally {
      _isLoading = false;
    }
  }

  void goToNotificationDetails(
      int? pushId, int? notifyClicks, BuildContext context) {
    if (pushId != null) {
      context.push(
        route: ZodiacNotificationDetails(
          pushId: pushId,
          needRefreshList: notifyClicks == 0,
        ),
      );
    }
  }
}
