import 'dart:io';

import 'package:zodiac/data/network/requests/authorized_request.dart';
import 'package:zodiac/data/network/responses/base_response.dart';

abstract class ZodiacChatRepository {
  Future<BaseResponse> sendImageToChat({
    required AuthorizedRequest request,
    required String mid,
    required File image,
  });
}
