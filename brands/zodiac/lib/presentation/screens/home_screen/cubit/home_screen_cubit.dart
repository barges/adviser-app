import 'package:shared_advisor_interface/infrastructure/architecture/bloc/base_cubit.dart';
import 'package:shared_advisor_interface/infrastructure/architecture/bloc/base_state.dart';

import '../../../../domain/usecase/home_screen_usecase.dart';

class HomeScreenCubit extends BaseCubit {
  HomeScreenCubit(this.useCase) : super(InitialState());

  final HomeScreenUseCase useCase;

  Future<void> getDate() async {
    emit(LoadingState());
    final response = await useCase.getData();
    if (response.success) {
      emit(SuccessState<String>(response.data!));
    } else {
      emit(FailureState(response.error));
    }
  }
}
