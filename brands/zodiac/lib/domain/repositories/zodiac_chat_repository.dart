import 'dart:io';

import 'package:zodiac/data/network/requests/authorized_request.dart';
import 'package:zodiac/data/network/requests/base_audio_message_request.dart';
import 'package:zodiac/data/network/requests/create_audio_message_request.dart';
import 'package:zodiac/data/network/responses/create_audio_message_response.dart';
import 'package:zodiac/data/network/responses/send_image_response.dart';
import 'package:zodiac/data/network/responses/upload_audio_message_response.dart';

abstract class ZodiacChatRepository {
  Future<SendImageResponse> sendImageToChat({
    required AuthorizedRequest request,
    required String mid,
    required File image,
    required String clientId,
  });

  Future<CreateAudioMessageResponse> createAudioMessage(
      {required CreateAudioMessageRequest request});

  Future<UploadAudioMessageResponse> uploadAudioMessage({
    required BaseAudioMessageRequest request,
    required int entityId,
    required File audioFile,
  });
}
