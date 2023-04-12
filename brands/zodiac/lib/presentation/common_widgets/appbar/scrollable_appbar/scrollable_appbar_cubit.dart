import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zodiac/presentation/common_widgets/appbar/scrollable_appbar/scrollable_appbar_state.dart';
import 'package:zodiac/zodiac_main_cubit.dart';

class ScrollableAppBarCubit extends Cubit<ScrollableAppBarState> {
  final ZodiacMainCubit _mainCubit;

  ScrollableAppBarCubit(this._mainCubit) : super(ScrollableAppBarState());

  void setIsWideAppbar(bool isWide) {
    emit(state.copyWith(isWideAppBar: isWide));
  }

  void closeErrorWidget() {
    _mainCubit.clearErrorMessage();
  }
}
