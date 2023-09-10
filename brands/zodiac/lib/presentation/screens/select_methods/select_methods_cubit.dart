import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zodiac/data/models/user_info/category_info.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';
import 'package:zodiac/data/network/responses/specializations_response.dart';
import 'package:zodiac/domain/repositories/zodiac_edit_profile_repository.dart';
import 'package:zodiac/presentation/screens/select_methods/select_methods_state.dart';

const int maxMethodsCount = 3;

class SelectMethodsCubit extends Cubit<SelectMethodsState> {
  final ZodiacEditProfileRepository _editProfileRepository;
  final List<int> _selectedMethodsIds;
  final int? _mainMethodId;
  final Function(List<CategoryInfo>, int) _returnCallback;

  SelectMethodsCubit(
    this._selectedMethodsIds,
    this._mainMethodId,
    this._returnCallback,
    this._editProfileRepository,
  ) : super(const SelectMethodsState()) {
    emit(state.copyWith(
      selectedIds: _selectedMethodsIds,
      mainMethodId: _mainMethodId,
    ));

    getMethods();
  }

  Future<void> getMethods() async {
    SpecializationsResponse response =
        await _editProfileRepository.getMethods(AuthorizedRequest());

    if (response.status == true) {
      emit(state.copyWith(methods: response.result));
    }
  }
}
