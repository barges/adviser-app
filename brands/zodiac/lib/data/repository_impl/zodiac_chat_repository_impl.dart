import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:zodiac/data/network/api/chat_api.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';
import 'package:zodiac/data/network/responses/send_image_response.dart';
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
}
