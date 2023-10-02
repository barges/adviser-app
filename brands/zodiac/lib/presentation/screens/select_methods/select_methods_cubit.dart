import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.gr.dart';
import 'package:zodiac/data/models/user_info/category_info.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';
import 'package:zodiac/data/network/responses/specializations_response.dart';
import 'package:zodiac/domain/repositories/zodiac_edit_profile_repository.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/screens/categories_methods_list/categories_methods_list_screen.dart';
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

  void onMethodSelectChange(int? id) {
    final List<int> selectedIds = List.of(state.selectedIds, growable: true);

    if (selectedIds.contains(id)) {
      selectedIds.remove(id);
      if (id == state.mainMethodId) {
        emit(state.copyWith(mainMethodId: null));
      }
    } else if (selectedIds.length < maxMethodsCount && id != null) {
      selectedIds.add(id);
    }

    emit(state.copyWith(selectedIds: selectedIds));
  }

  Future<void> selectMainMethod(BuildContext context) async {
    final List<CategoriesMethodsListItem> selectedItems = [];
    state.methods?.forEach((element) {
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
            title: SZodiac.of(context).mainMethodZodiac,
            items: selectedItems,
            initialSelectedId: state.mainMethodId,
            returnCallback: setMainMethodId));
  }

  void setMainMethodId(int id) {
    emit(state.copyWith(mainMethodId: id));
  }

  void saveChanges(BuildContext context) {
    List<CategoryInfo> selectedCategories = [];

    state.methods?.forEach((element) {
      if (state.selectedIds.contains(element.id)) {
        selectedCategories.add(element);
      }
    });

    if (state.mainMethodId != null) {
      _returnCallback(selectedCategories, state.mainMethodId!);
      context.pop();
    }
  }
}
