import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../main_cubit.dart';
import 'scrollable_appbar_state.dart';

class ScrollableAppBarCubit extends Cubit<ScrollableAppBarState> {
  final MainCubit _mainCubit;

  ScrollableAppBarCubit(this._mainCubit) : super(ScrollableAppBarState());

  void setIsWideAppbar(bool isWide) {
    emit(state.copyWith(isWideAppBar: isWide));
  }

  void closeErrorWidget() {
    _mainCubit.clearErrorMessage();
  }
}
