import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/data/models/app_error/app_error.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:zodiac/data/models/chat/chat_message_model.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';
import 'package:zodiac/data/network/responses/send_image_response.dart';
import 'package:zodiac/domain/repositories/zodiac_chat_repository.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/services/websocket_manager/created_delivered_event.dart';
import 'package:zodiac/services/websocket_manager/websocket_manager.dart';
import 'package:zodiac/zodiac_main_cubit.dart';

import 'resend_message_state.dart';

class ResendMessageCubit extends Cubit<ResendMessageState> {
  final ChatMessageModel _chatMessageModel;
  final String? _roomId;
  final int? _opponentId;
  final WebSocketManager _webSocketManager;
  final ZodiacChatRepository _chatRepository;
  final bool isImage;
  final ZodiacMainCubit _zodiacMainCubit;
  final ValueSetter<String?> deleteMessage;
  final ValueSetter<CreatedDeliveredEvent> updateImageIsDelivered;

  StreamSubscription<CreatedDeliveredEvent>? _messageDeliveredSubscription;

  Timer? _resendTimer;

  static List<String> sendingImagesMids = [];

  int _resendCount = 0;
  ResendMessageCubit(
    this._chatMessageModel,
    this._roomId,
    this._opponentId,
    this._webSocketManager,
    this._zodiacMainCubit,
    this.isImage,
    this._chatRepository,
    this.deleteMessage,
    this.updateImageIsDelivered,
    BuildContext context,
  ) : super(const ResendMessageState()) {
    logger.d('CREATE');
    if (_chatMessageModel.isOutgoing && !_chatMessageModel.isDelivered) {
      if (!isImage) {
        _setTimer();
        _messageDeliveredSubscription =
            _webSocketManager.updateMessageIdStream.listen((event) {
          if (event.mid == _chatMessageModel.mid) {
            _resendTimer?.cancel();
            _resendCount = 0;
            emit(state.copyWith(showResendWidget: false));
            _messageDeliveredSubscription?.cancel();
          }
        });
      }
      if (isImage && !sendingImagesMids.contains(_chatMessageModel.mid)) {
        _resendImage(context);
      }
    }
  }

  @override
  Future<void> close() {
    _resendTimer?.cancel();
    _messageDeliveredSubscription?.cancel();
    return super.close();
  }

  void resendChatMessage(BuildContext context) {
    emit(state.copyWith(showResendWidget: false));

    if (isImage) {
      _resendImage(context);
    } else {
      _resendMessage();
      _resendCount = 0;
      _setTimer();
    }
  }

  Future<void> _resendImage(BuildContext context) async {
    if (_chatMessageModel.mid != null && _chatMessageModel.mainImage != null) {
      try {
        sendingImagesMids.add(_chatMessageModel.mid!);

        final SendImageResponse response =
            await _chatRepository.sendImageToChat(
          request: AuthorizedRequest(),
          mid: _chatMessageModel.mid!,
          image: File(_chatMessageModel.mainImage!),
          clientId: _opponentId.toString(),
        );

        if (response.status == true) {
          updateImageIsDelivered(CreatedDeliveredEvent(
              mid: _chatMessageModel.mid!, clientId: _opponentId ?? 0));
        } else {
          if (response.errorCode == 3) {
            _zodiacMainCubit.updateErrorMessage(NetworkError(
                message: SZodiac.of(context).theMaximumImageSizeIs10MbZodiac));
            deleteMessage(_chatMessageModel.mid);
          }

          emit(state.copyWith(showResendWidget: true));
        }
      } catch (e) {
        logger.d(e);
        emit(state.copyWith(showResendWidget: true));
      } finally {
        sendingImagesMids.remove(_chatMessageModel.mid);
      }
    }
  }

  void _resendMessage() {
    _webSocketManager.sendMessageToChat(
      message: _chatMessageModel,
      roomId: _roomId ?? '',
      opponentId: _opponentId ?? 0,
    );
  }

  void _setTimer() {
    _resendTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      logger.d('Timer');

      if (_resendCount < 3) {
        _resendMessage();
        _resendCount++;
      } else {
        emit(state.copyWith(showResendWidget: true));
        _resendTimer?.cancel();
      }
    });
  }
}
