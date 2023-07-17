import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zodiac/data/models/services/service_language_model.dart';
import 'package:zodiac/presentation/screens/add_service/add_service_state.dart';

class AddServiceCubit extends Cubit<AddServiceState> {
  AddServiceCubit() : super(const AddServiceState()) {
    emit(state.copyWith(languagesList: [
      const ServiceLanguageModel(title: 'English'),
      const ServiceLanguageModel(title: 'Spanish')
    ]));
  }
}
