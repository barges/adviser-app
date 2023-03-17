import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortunica/fortunica_main_cubit.dart';
import 'package:fortunica/presentation/common_widgets/appbar/scrollable_appbar/scrollable_appbar_state.dart';

class ScrollableAppBarCubit extends Cubit<ScrollableAppBarState> {
  final FortunicaMainCubit _mainCubit;

  ScrollableAppBarCubit(this._mainCubit) : super(ScrollableAppBarState());

  void setIsWideAppbar(bool isWide) {
    emit(state.copyWith(isWideAppBar: isWide));
  }

  void closeErrorWidget() {
    _mainCubit.clearErrorMessage();
  }
}
