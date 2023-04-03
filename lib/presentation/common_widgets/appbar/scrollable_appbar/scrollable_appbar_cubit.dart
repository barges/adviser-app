import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/appbar/scrollable_appbar/scrollable_appbar_state.dart';

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
