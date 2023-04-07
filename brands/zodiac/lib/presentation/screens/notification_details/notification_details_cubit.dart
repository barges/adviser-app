import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:zodiac/data/network/requests/notification_details_request.dart';
import 'package:zodiac/data/network/responses/base_response.dart';
import 'package:zodiac/data/network/responses/notification_details_response.dart';
import 'package:zodiac/domain/repositories/zodiac_user_repository.dart';
import 'package:zodiac/presentation/screens/notification_details/notification_details_state.dart';
import 'package:zodiac/zodiac_main_cubit.dart';

class NotificationDetailsCubit extends Cubit<NotificationDetailsState> {
  final ZodiacUserRepository _userRepository;
  final ZodiacMainCubit _zodiacMainCubit;

  NotificationDetailsCubit(
    int pushId,
    bool needRefreshList,
    this._userRepository,
    this._zodiacMainCubit,
  ) : super(const NotificationDetailsState()) {
    _getNotificationContent(pushId);
    _notifyPushClick(pushId, needRefreshList);
  }

  Future<void> _getNotificationContent(int pushId) async {
    try {
      NotificationDetailsResponse response = await _userRepository
          .getNotificationDetails(NotificationDetailsRequest(pushId: pushId));
      if (response.status == true) {
        emit(state.copyWith(notificationContent: response.result));
      }
    } catch (e) {
      logger.d(e);
    }
  }

  Future<void> _notifyPushClick(int pushId, bool needRefreshList) async {
    try {
      BaseResponse response = await _userRepository
          .notifyPushClick(NotificationDetailsRequest(pushId: pushId));
      if (response.status == true && needRefreshList) {
        _zodiacMainCubit.updateNotificationsList();
      }
    } catch (e) {
      logger.d(e);
    }
  }
}
