import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/global.dart';
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
     List<CategoryInfo>? responseCategories;


     if(_cachingManager.haveCategories){
       responseCategories = _cachingManager.getAllCategories();
     } else {
       responseCategories = (await _userRepository.getSpecializations(AuthorizedRequest()))
           .result;
       if (responseCategories != null) {
         responseCategories = CategoryInfo.normalizeList(responseCategories);
         _cachingManager.saveAllCategories(responseCategories);
       }
     }

    if (responseCategories != null) {
      emit(state.copyWith(
        categories: responseCategories,
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
