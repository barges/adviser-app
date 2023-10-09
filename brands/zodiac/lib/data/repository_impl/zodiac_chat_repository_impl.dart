import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:zodiac/data/network/api/chat_api.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';
import 'package:zodiac/data/network/requests/base_audio_message_request.dart';
import 'package:zodiac/data/network/requests/create_audio_message_request.dart';
import 'package:zodiac/data/network/responses/auto_reply_list_response.dart';
import 'package:zodiac/data/network/responses/create_audio_message_response.dart';
import 'package:zodiac/data/network/responses/send_image_response.dart';
import 'package:zodiac/data/network/responses/upload_audio_message_response.dart';
import 'package:zodiac/domain/repositories/zodiac_chat_repository.dart';

@Injectable(as: ZodiacChatRepository)
class ZodiacChatRepositoryImpl implements ZodiacChatRepository {
  final ChatApi _chatApi;

  const ZodiacChatRepositoryImpl(this._chatApi);

  @override
  Future<SendImageResponse> sendImageToChat({
    required AuthorizedRequest request,
    required String mid,
    required File image,
    required String clientId,
  }) async {
    return await _chatApi.sendImageToChat(
      secret: request.secret,
      package: request.package,
      version: request.version,
      auth: request.auth,
      mid: mid,
      image: image,
      clientId: clientId,
    );
  }

  @override
  Future<CreateAudioMessageResponse> createAudioMessage(
      {required CreateAudioMessageRequest request}) async {
    return await _chatApi.createAudioMessage(request: request);
  }

  @override
  Future<UploadAudioMessageResponse> uploadAudioMessage({
    required BaseAudioMessageRequest request,
    required int entityId,
    required File audioFile,
  }) async {
    return await _chatApi.uploadAudioMessage(
      secret: request.secret,
      auth: request.auth,
      entityId: entityId,
      audioFile: audioFile,
    );
  }

  @override
  Future<AutoReplyListResponse> getAutoReplyList(
      AuthorizedRequest request) async {
    return await _chatApi.getAutoReplyList(request);
  }
}
