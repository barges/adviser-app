import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.gr.dart';
import 'package:zodiac/data/models/user_info/category_info.dart';
import 'package:zodiac/data/network/requests/list_request.dart';
import 'package:zodiac/data/network/responses/specializations_response.dart';
import 'package:zodiac/domain/repositories/zodiac_edit_profile_repository.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/screens/select_categories/select_categories_state.dart';
import 'package:zodiac/presentation/screens/categories_methods_list/categories_methods_list_screen.dart';

const int maxCategoriesCount = 3;

class SelectCategoriesCubit extends Cubit<SelectCategoriesState> {
  final ZodiacEditProfileRepository _editProfileRepository;
  final List<int> _selectedCategoryIds;
  final int? _mainCategoryId;
  final Function(List<CategoryInfo>, int) _returnCallback;

  SelectCategoriesCubit(
    this._selectedCategoryIds,
    this._mainCategoryId,
    this._returnCallback,
    this._editProfileRepository,
  ) : super(const SelectCategoriesState()) {
    emit(state.copyWith(
      selectedIds: _selectedCategoryIds,
      mainCategoryId: _mainCategoryId,
    ));

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

  Future<void> selectMainCategory(BuildContext context) async {
    final List<CategoriesMethodsListItem> selectedItems = [];
    state.categories?.forEach((element) {
      if (state.selectedIds.contains(element.id)) {
        selectedItems.add(
          CategoriesMethodsListItem(
            id: element.id!,
            name: element.name ?? '',
          ),
        );
      }
    });

    context.push(
        route: ZodiacCategoriesMethodsList(
            title: SZodiac.of(context).mainCategoryZodiac,
            items: selectedItems,
            initialSelectedId: state.mainCategoryId,
            returnCallback: setMainCategoryId));
  }

  void setMainCategoryId(int id) {
    emit(state.copyWith(mainCategoryId: id));
  }

  void onCategorySelectChange(int? id) {
    final List<int> selectedIds = List.of(state.selectedIds, growable: true);

    if (selectedIds.contains(id)) {
      selectedIds.remove(id);
      if (id == state.mainCategoryId) {
        emit(state.copyWith(mainCategoryId: null));
      }
    } else if (selectedIds.length < maxCategoriesCount && id != null) {
      selectedIds.add(id);
    }

    emit(state.copyWith(selectedIds: selectedIds));
  }

  void saveChanges(BuildContext context) {
    List<CategoryInfo> selectedCategories = [];

    state.categories?.forEach((element) {
      if (state.selectedIds.contains(element.id)) {
        selectedCategories.add(element);
      }
    });

    if (state.mainCategoryId != null) {
      _returnCallback(selectedCategories, state.mainCategoryId!);
      context.pop();
    }
  }
}
