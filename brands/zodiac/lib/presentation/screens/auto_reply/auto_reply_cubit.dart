import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:zodiac/data/models/chat/private_message_model.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';
import 'package:zodiac/data/network/requests/auto_reply_settings_request.dart';
import 'package:zodiac/data/network/responses/auto_reply_list_response.dart';
import 'package:zodiac/data/network/responses/auto_reply_settings_response.dart';
import 'package:zodiac/domain/repositories/zodiac_chat_repository.dart';
import 'package:zodiac/presentation/screens/auto_reply/auto_reply_constants.dart';
import 'package:zodiac/presentation/screens/auto_reply/auto_reply_state.dart';

@injectable
class AutoReplyCubit extends Cubit<AutoReplyState> {
  final ZodiacChatRepository _chatRepository;

  AutoReplyCubit(
    this._chatRepository,
  ) : super(const AutoReplyState()) {
    _getInitialData();
  }

  Future<void> _getInitialData() async {
    try {
      final AutoReplyListResponse listResponse =
          await _chatRepository.getAutoReplyList(AuthorizedRequest());

      if (listResponse.status == true) {
        List<PrivateMessageModel>? messages = listResponse.result;

        final AutoReplySettingsResponse settingsResponse =
            await _chatRepository.autoReplySettings(AutoReplySettingsRequest());

        if (settingsResponse.status == true) {
          PrivateMessageModel? messageModel = settingsResponse.result;

          logger.d(messageModel);

          if (messageModel != null) {
            int? messageIndex = messages
                ?.indexWhere((element) => element.id == messageModel.messageId);

            if (messageIndex != null && messageIndex != -1) {
              messages![messageIndex] = messageModel;
            }
          }

          emit(
            state.copyWith(
              autoReplyEnabled: messageModel?.autoreplied == true,
              messages: messages,
              time: messageModel?.time ?? AutoReplyConstants.time,
              timeFrom: messageModel?.timeFrom ?? AutoReplyConstants.timeFrom,
              timeTo: messageModel?.timeTo ?? AutoReplyConstants.timeTo,
            ),
          );
        }
      }
    } catch (e) {
      logger.d(e);
    } finally {
      emit(state.copyWith(dataFetched: state.messages != null));
    }
  }

  void selectMessage(int? id) {
    emit(state.copyWith(selectedMessageId: id));
  }

  void setSingleTime(String time) {
    List<PrivateMessageModel>? messages = List.of(state.messages ?? []);

    PrivateMessageModel? privateMessage = messages.firstWhereOrNull(
        (element) => element.message?.contains(state.time) == true);
    if (privateMessage != null) {
      int? messageIndex = messages.indexOf(privateMessage);

      String message =
          privateMessage.message?.replaceFirst(state.time, time) ?? '';

      messages[messageIndex] = privateMessage.copyWith(message: message);

      emit(state.copyWith(messages: messages, time: time));
    }
  }

  void setTimeFrom(String time) {
    List<PrivateMessageModel>? messages = List.of(state.messages ?? []);

    PrivateMessageModel? privateMessage = messages.firstWhereOrNull(
        (element) => element.message?.contains(state.timeFrom) == true);
    if (privateMessage != null) {
      int? messageIndex = messages.indexOf(privateMessage);

      String message =
          privateMessage.message?.replaceFirst(state.timeFrom, time) ?? '';

      messages[messageIndex] = privateMessage.copyWith(message: message);

      emit(state.copyWith(messages: messages, timeFrom: time));
    }
  }

  void setTimeTo(String time) {
    List<PrivateMessageModel>? messages = List.of(state.messages ?? []);

    PrivateMessageModel? privateMessage = messages.firstWhereOrNull(
        (element) => element.message?.contains(state.timeTo) == true);
    if (privateMessage != null) {
      int? messageIndex = messages.indexOf(privateMessage);

      String message =
          privateMessage.message?.replaceFirst(state.timeTo, time) ?? '';

      messages[messageIndex] = privateMessage.copyWith(message: message);

      emit(state.copyWith(messages: messages, timeTo: time));
    }
  }
}
