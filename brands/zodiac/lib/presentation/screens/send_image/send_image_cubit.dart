import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zodiac/data/cache/zodiac_caching_manager.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';
import 'package:zodiac/domain/repositories/zodiac_chat_repository.dart';
import 'package:zodiac/presentation/screens/send_image/send_image_state.dart';

class SendImageCubit extends Cubit<SendImageState> {
  final ZodiacCachingManager _cachingManager;
  final ZodiacChatRepository _chatRepository;
  final File _image;

  SendImageCubit(
    this._cachingManager,
    this._chatRepository,
    this._image,
  ) : super(const SendImageState());

  @override
  Future<void> close() {
    return super.close();
  }

  Future<void> sendImageToChat() async {
    await _chatRepository.sendImageToChat(
      request: AuthorizedRequest(),
      mid: _generateMessageId(),
      image: _image,
    );
  }

  String _generateMessageId() {
    final expertId = _cachingManager.getUid();
    return '${expertId}_${DateTime.now().millisecondsSinceEpoch ~/ 1000}';
  }
}
