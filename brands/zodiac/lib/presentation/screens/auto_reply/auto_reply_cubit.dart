import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
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

  bool _savingInProgress = false;

  AutoReplyCubit(
    this._chatRepository,
  ) : super(const AutoReplyState()) {
    getInitialData();
  }

  Future<void> getInitialData() async {
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
              messages![messageIndex] =
                  messageModel.copyWith(id: messageModel.messageId);
            }
          }

          emit(
            state.copyWith(
              autoReplyEnabled: messageModel?.autoreplied == true,
              messages: messages,
              time: messageModel?.time ?? AutoReplyConstants.time,
              timeFrom: messageModel?.timeFrom ?? AutoReplyConstants.timeFrom,
              timeTo: messageModel?.timeTo ?? AutoReplyConstants.timeTo,
              selectedMessageId: messageModel?.messageId,
            ),
          );
        }
      }
    } catch (e) {
      logger.d(e);
    } finally {
      emit(state.copyWith(
        dataFetched: state.messages != null,
        alreadyTriedToFetchData: true,
      ));
    }
  }

  void selectMessage(int? id) {
    emit(state.copyWith(selectedMessageId: id));
  }

  void setSingleTime(String time) {
    List<PrivateMessageModel>? messages = List.of(state.messages ?? []);

    PrivateMessageModel? privateMessage = messages
        .firstWhereOrNull((element) => isSingleTimeMessage(element.message));
    if (privateMessage != null) {
      int? messageIndex = messages.indexOf(privateMessage);

      String message =
          privateMessage.message?.replaceFirst(state.time, time) ?? '';

      messages[messageIndex] = privateMessage.copyWith(message: message);

      emit(state.copyWith(messages: messages, time: time));
    }
  }

  void setTimeFrom(String time) {
    if (time != state.timeTo) {
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
  }

  void setTimeTo(String time) {
    if (time != state.timeFrom) {
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

  void onAutoReplyEnabledChange(bool value) {
    emit(state.copyWith(autoReplyEnabled: value));
  }

  Future<void> saveChanges(BuildContext context) async {
    if (!_savingInProgress) {
      try {
        _savingInProgress = true;
        final bool autoReplyEnabled = state.autoReplyEnabled;
        AutoReplySettingsRequest? request;
        if (autoReplyEnabled) {
          PrivateMessageModel? selectedMessage = state.messages
              ?.firstWhereOrNull(
                  (element) => element.id == state.selectedMessageId);

          if (selectedMessage?.message != null && selectedMessage?.id != null) {
            if (isSingleTimeMessage(selectedMessage!.message!) &&
                state.time != AutoReplyConstants.time) {
              request = AutoReplySettingsRequest(
                autoreplied: autoReplyEnabled,
                saveForm: 1,
                messageId: selectedMessage.id,
                time: state.time,
              );
            } else if (isMultiTimeMessage(selectedMessage.message) &&
                state.timeFrom != AutoReplyConstants.timeFrom &&
                state.timeTo != AutoReplyConstants.timeTo) {
              request = AutoReplySettingsRequest(
                autoreplied: autoReplyEnabled,
                saveForm: 1,
                messageId: selectedMessage.id,
                timeFrom: state.timeFrom,
                timeTo: state.timeTo,
              );
            } else {
              request = AutoReplySettingsRequest(
                autoreplied: autoReplyEnabled,
                saveForm: 1,
                messageId: selectedMessage.id,
              );
            }
          }
        } else {
          request = AutoReplySettingsRequest(
              autoreplied: autoReplyEnabled, saveForm: 1);
        }

        if (request != null) {
          final AutoReplySettingsResponse response =
              await _chatRepository.autoReplySettings(request);

          if (response.status == true) {
            // ignore: use_build_context_synchronously
            context.pop(autoReplyEnabled);
          }
        }
      } catch (e) {
        logger.d(e);
      } finally {
        _savingInProgress = false;
      }
    }
  }

  bool isSingleTimeMessage(String? message) {
    return message?.contains(state.time) == true;
  }

  bool isMultiTimeMessage(String? message) {
    return message?.contains(state.timeFrom) == true &&
        message?.contains(state.timeTo) == true;
  }
}
