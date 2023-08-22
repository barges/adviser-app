import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zodiac/presentation/screens/categories_methods_list/categories_methods_list_state.dart';

class CategoriesMethodsListCubit extends Cubit<CategoriesMethodsListState> {
  final int? _initialSelectedId;

  CategoriesMethodsListCubit(
    this._initialSelectedId,
  ) : super(const CategoriesMethodsListState()) {
    emit(state.copyWith(selectedId: _initialSelectedId));
  }

  void selectItem(int id) {
    emit(state.copyWith(selectedId: id));
  }
}
