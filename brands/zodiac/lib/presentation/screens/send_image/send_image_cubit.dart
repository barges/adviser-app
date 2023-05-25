import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:zodiac/data/cache/zodiac_caching_manager.dart';
import 'package:zodiac/data/models/enums/chat_message_type.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';
import 'package:zodiac/data/network/responses/send_image_response.dart';
import 'package:zodiac/domain/repositories/zodiac_chat_repository.dart';
import 'package:zodiac/presentation/screens/send_image/send_image_state.dart';

class SendImageCubit extends Cubit<SendImageState> {
  final ZodiacCachingManager _cachingManager;
  final ZodiacChatRepository _chatRepository;
  final File _image;
  final String _clientId;

  SendImageCubit(
    this._cachingManager,
    this._chatRepository,
    this._image,
    this._clientId,
  ) : super(const SendImageState());

  @override
  Future<void> close() {
    return super.close();
  }

  Future<void> sendImageToChat(BuildContext context) async {
    try {
      SendImageResponse response = await _chatRepository.sendImageToChat(
        request: AuthorizedRequest(),
        mid: _generateMessageId(),
        image: _image,
        clientId: _clientId,
      );
      if (response.status == true && response.result?.isNotEmpty == true) {
        // ignore: use_build_context_synchronously
        context.pop(response.result![0].copyWith(
          type: ChatMessageType.typeFromInt(10),
          isOutgoing: true,
          utc: DateTime.now().toUtc(),
          fromAdvisor: true,
        ));
      }
    } catch (e) {
      logger.d(e);
    }
  }

  String _generateMessageId() {
    final expertId = _cachingManager.getUid();
    return '${expertId}_${DateTime.now().millisecondsSinceEpoch ~/ 1000}';
  }
}
