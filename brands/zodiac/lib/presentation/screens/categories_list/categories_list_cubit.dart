import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:zodiac/data/network/requests/list_request.dart';
import 'package:zodiac/data/network/responses/specializations_response.dart';
import 'package:zodiac/domain/repositories/zodiac_edit_profile_repository.dart';
import 'package:zodiac/presentation/screens/categories_list/categories_list_state.dart';

class CategoriesListCubit extends Cubit<CategoriesListState> {
  final ZodiacEditProfileRepository _editProfileRepository;
  final List<int> _selectedCategoryIds;

  CategoriesListCubit(
    this._selectedCategoryIds,
    this._editProfileRepository,
  ) : super(const CategoriesListState()) {
    emit(state.copyWith(selectedIds: _selectedCategoryIds));

    getCategories();
  }

  Future<void> getCategories() async {
    SpecializationsResponse response = await _editProfileRepository
        .getCategories(ListRequest(count: 20, offset: 0));
    logger.d(response.status);

    if (response.status == true) {
      emit(state.copyWith(categories: response.result));
    }
  }
}
