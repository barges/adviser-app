import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';
import 'package:zodiac/data/network/requests/create_audio_message_request.dart';
import 'package:zodiac/data/network/responses/auto_reply_list_response.dart';
import 'package:zodiac/data/network/responses/create_audio_message_response.dart';
import 'package:zodiac/data/network/responses/send_image_response.dart';
import 'package:zodiac/data/network/responses/upload_audio_message_response.dart';

part 'chat_api.g.dart';

@RestApi()
@injectable
abstract class ChatApi {
  @factoryMethod
  factory ChatApi(Dio dio) = _ChatApi;

  @POST('/entities/{clientId}/images')
  @MultiPart()
  Future<SendImageResponse> sendImageToChat({
    @Part(name: 'secret') String? secret,
    @Part(name: 'package') String? package,
    @Part(name: 'version') String? version,
    @Part(name: 'auth') String? auth,
    @Part(name: 'mid') String? mid,
    @Part(name: 'image') File? image,
    @Path('clientId') required String clientId,
  });

  @POST('/entities/create-audio-message')
  Future<CreateAudioMessageResponse> createAudioMessage(
      {@Body() required CreateAudioMessageRequest request});

  @POST('/entities/upload-audio-message')
  @MultiPart()
  Future<UploadAudioMessageResponse> uploadAudioMessage({
    @Part(name: 'secret') String? secret,
    @Part(name: 'auth') String? auth,
    @Part(name: 'entity_id') int? entityId,
    @Part(name: 'audio_file') File? audioFile,
  });

  @POST('/private-messages/list')
  Future<AutoReplyListResponse> getAutoReplyList(
      @Body() AuthorizedRequest request);
}
