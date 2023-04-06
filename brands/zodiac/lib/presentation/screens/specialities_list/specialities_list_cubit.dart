import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zodiac/data/cache/zodiac_caching_manager.dart';
import 'package:zodiac/data/models/user_info/category_info.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';
import 'package:zodiac/domain/repositories/zodiac_user_repository.dart';
import 'package:zodiac/presentation/screens/specialities_list/specialities_list_state.dart';

class SpecialitiesListCubit extends Cubit<SpecialitiesListState> {
  final ZodiacUserRepository _userRepository;
  final ZodiacCachingManager _cachingManager;
  final List<CategoryInfo> _oldSelectedCategories;
  final bool _isMultiselect;

  SpecialitiesListCubit(
    this._userRepository,
    this._cachingManager,
    this._oldSelectedCategories,
    this._isMultiselect,
  ) : super(const SpecialitiesListState()) {
    getAllCategories();
  }

  Future<void> getAllCategories() async {
    final List<CategoryInfo>? responseCategories =
        _cachingManager.getAllCategories() ??
            ((await _userRepository.getSpecializations(AuthorizedRequest()))
                .result);

    if (responseCategories != null) {
      final List<CategoryInfo> categories = [];

      for (CategoryInfo categoryInfo in responseCategories) {
        categories.add(categoryInfo);
        List<CategoryInfo>? sublist = categoryInfo.sublist;
        if (sublist != null) {
          for (CategoryInfo subCategoryInfo in sublist) {
            categories.add(subCategoryInfo);
          }
        }
      }

      emit(state.copyWith(
        categories: categories,
        selectedCategories: _oldSelectedCategories,
      ));
    }
  }

  void tapToCategory(int index) {
    final List<CategoryInfo> allCategories = state.categories;
    if (index < allCategories.length) {
      final CategoryInfo categoryInfo = allCategories[index];
      List<CategoryInfo> selectedCategories =
          List.from(state.selectedCategories);

      if (_isMultiselect) {
        if (selectedCategories
            .any((element) => categoryInfo.id == element.id)) {
          selectedCategories
              .removeWhere((element) => categoryInfo.id == element.id);
        } else {
          selectedCategories.add(categoryInfo);
        }
      } else {
        selectedCategories = [categoryInfo];
      }

      emit(state.copyWith(
        selectedCategories: selectedCategories,
      ));
    }
  }
}
