import 'dart:io';

import 'package:zodiac/data/network/requests/authorized_request.dart';
import 'package:zodiac/data/network/responses/send_image_response.dart';

abstract class ZodiacChatRepository {
  Future<SendImageResponse> sendImageToChat({
    required AuthorizedRequest request,
    required String mid,
    required File image,
    required String clientId,
  });
}
