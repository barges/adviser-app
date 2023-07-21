import 'package:injectable/injectable.dart';
import 'package:zodiac/data/network/api/services_api.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';
import 'package:zodiac/data/network/responses/default_services_images_response.dart';
import 'package:zodiac/domain/repositories/zodiac_sevices_repository.dart';

@Injectable(as: ZodiacServicesRepository)
class ZodiacServicesRepositoryImpl implements ZodiacServicesRepository {
  final ServicesApi _api;

  ZodiacServicesRepositoryImpl(this._api);

  @override
  Future<DefaultServicesImagesResponse> getDefaultImages(
      AuthorizedRequest request) async {
    return await _api.getDefaultImages(request);
  }
}
