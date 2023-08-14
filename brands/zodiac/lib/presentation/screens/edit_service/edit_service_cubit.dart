import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:zodiac/data/models/services/image_sample_model.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';
import 'package:zodiac/data/network/requests/get_service_info_request.dart';
import 'package:zodiac/data/network/responses/default_services_images_response.dart';
import 'package:zodiac/data/network/responses/get_service_info_response.dart';
import 'package:zodiac/domain/repositories/zodiac_sevices_repository.dart';
import 'package:zodiac/presentation/screens/edit_service/edit_service_state.dart';

class EditServiceCubit extends Cubit<EditServiceState> {
  final int serviceId;
  final ZodiacServicesRepository servicesRepository;

  EditServiceCubit({
    required this.serviceId,
    required this.servicesRepository,
  }) : super(const EditServiceState()) {
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      await _getImages();
      await _getServiceInfo();
    } catch (e) {
      logger.d(e);
    } finally {
      emit(state.copyWith(alreadyFetchData: true));
    }
  }

  Future<void> _getImages() async {
    final DefaultServicesImagesResponse response =
        await servicesRepository.getDefaultImages(AuthorizedRequest());

    if (response.status == true) {
      List<ImageSampleModel>? images = response.samples;

      emit(state.copyWith(images: images));
    }
  }

  Future<void> _getServiceInfo() async {
    final GetServiceInfoResponse response = await servicesRepository
        .getServiceInfo(GetServiceInfoRequest(serviceId: serviceId));
  }
}
