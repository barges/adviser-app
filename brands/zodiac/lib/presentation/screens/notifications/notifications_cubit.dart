import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:zodiac/data/models/notification/notification_item.dart';
import 'package:zodiac/data/network/requests/list_request.dart';
import 'package:zodiac/data/network/responses/notifications_response.dart';
import 'package:zodiac/domain/repositories/zodiac_user_repository.dart';
import 'package:zodiac/presentation/screens/notifications/notifications_state.dart';

const int _count = 10;

class NotificationsCubit extends Cubit<NotificationsState> {
  final ZodiacUserRepository _userRepository;

  final ScrollController scrollController = ScrollController();

  bool _isLoading = false;
  bool _hasMore = true;
  List<NotificationItem> _notificationsList = [];

  NotificationsCubit(this._userRepository, double screenHeight)
      : super(const NotificationsState()) {
    getNotifications();

    scrollController.addListener(() {
      if (!_isLoading &&
          scrollController.position.extentAfter <= screenHeight) {
        getNotifications();
      }
    });
  }

  Future<void> getNotifications({bool refresh = false}) async {
    try {
      _isLoading = true;
      if (refresh) {
        _notificationsList.clear();
        _hasMore = true;
      }
      if (_hasMore) {
        NotificationsResponse response =
            await _userRepository.getNotificationsList(
          ListRequest(
            count: _count,
            offset: _notificationsList.length,
          ),
        );
        if (response.errorCode == 0) {
          _notificationsList.addAll(response.result ?? []);
          _hasMore = response.count != null &&
              _notificationsList.length < response.count!;
          emit(state.copyWith(notifications: List.of(_notificationsList)));
        }
      }
    } catch (e) {
      logger.d(e);
    } finally {
      _isLoading = false;
    }
  }
}
