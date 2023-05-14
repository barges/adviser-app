import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:zodiac/data/network/responses/base_response.dart';

part 'chat_api.g.dart';

@RestApi()
@injectable
abstract class ChatApi {
  @factoryMethod
  factory ChatApi(Dio dio) = _ChatApi;

  @POST('/upload-avatar')
  @MultiPart()
  Future<BaseResponse> sendImageToChat({
    @Part(name: 'secret') String? secret,
    @Part(name: 'package') String? package,
    @Part(name: 'version') String? version,
    @Part(name: 'auth') String? auth,
    @Part(name: 'mid') String? mid,
    @Part(name: 'image') File? image,
  });
}
