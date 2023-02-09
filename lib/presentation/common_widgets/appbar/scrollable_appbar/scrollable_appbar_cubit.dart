import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/appbar/scrollable_appbar/scrollable_appbar_state.dart';

class ScrollableAppBarCubit extends Cubit<ScrollableAppBarState> {
  ScrollableAppBarCubit() : super(ScrollableAppBarState());

  void setIsWideAppbar(bool isWide) {
    emit(state.copyWith(isWideAppBar: isWide));
  }
}
