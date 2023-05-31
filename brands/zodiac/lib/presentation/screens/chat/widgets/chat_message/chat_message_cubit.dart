import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/data/models/app_error/app_error.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:zodiac/data/models/chat/chat_message_model.dart';
import 'package:zodiac/data/models/chat/image_is_delivered.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';
import 'package:zodiac/data/network/responses/send_image_response.dart';
import 'package:zodiac/domain/repositories/zodiac_chat_repository.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/services/websocket_manager/created_delivered_event.dart';
import 'package:zodiac/services/websocket_manager/websocket_manager.dart';
import 'package:zodiac/zodiac_main_cubit.dart';

import 'chat_message_state.dart';

class ChatMessageCubit extends Cubit<ChatMessageState> {
  final ChatMessageModel _chatMessageModel;
  final String? _roomId;
  final int? _opponentId;
  final WebSocketManager _webSocketManager;
  final ZodiacChatRepository _chatRepository;
  final bool isImage;
  final ZodiacMainCubit _zodiacMainCubit;

  StreamSubscription<CreatedDeliveredEvent>? _messageDeliveredSubscription;
  StreamSubscription<ImageIsDelivered>? _imageIsDeliveredSubscription;

  Timer? _resendTimer;

  int _resendCount = 0;
  ChatMessageCubit(
    this._chatMessageModel,
    this._roomId,
    this._opponentId,
    this._webSocketManager,
    this._zodiacMainCubit,
    this.isImage,
    Stream<ImageIsDelivered> imageNotDeliveredStream,
    this._chatRepository,
  ) : super(const ChatMessageState()) {
    if (_chatMessageModel.isOutgoing &&
        !_chatMessageModel.isDelivered &&
        !isImage) {
      logger.d('CREATE');
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
    if (isImage) {
      _imageIsDeliveredSubscription = imageNotDeliveredStream.listen((event) {
        if (_chatMessageModel.mid == event.mid) {
          if (event.isDelivered) {
            emit(state.copyWith(updateMessageIsDelivered: true));
            _imageIsDeliveredSubscription?.cancel();
          } else {
            emit(state.copyWith(showResendWidget: true));
          }
        }
      });
    }
  }

  @override
  Future<void> close() {
    _resendTimer?.cancel();
    _messageDeliveredSubscription?.cancel();
    _imageIsDeliveredSubscription?.cancel();
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
        final SendImageResponse response =
            await _chatRepository.sendImageToChat(
          request: AuthorizedRequest(),
          mid: _chatMessageModel.mid!,
          image: File(_chatMessageModel.mainImage!),
          clientId: _opponentId.toString(),
        );

        if (response.status == true) {
          emit(state.copyWith(updateMessageIsDelivered: true));
        } else {
          if (response.errorCode == 3) {
            _zodiacMainCubit.updateErrorMessage(NetworkError(
                message: SZodiac.of(context).theMaximumImageSizeIs10MbZodiac));
          }

          emit(state.copyWith(showResendWidget: true));
        }
      } catch (e) {
        logger.d(e);
        emit(state.copyWith(showResendWidget: true));
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
