import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zodiac/presentation/common_widgets/appbar/transparrent_app_bar/transparrent_app_bar_state.dart';
import 'package:zodiac/zodiac_main_cubit.dart';

class TransparrentAppBarCubit extends Cubit<TransparrentAppBarState> {
  final ZodiacMainCubit _zodiacMainCubit;

  TransparrentAppBarCubit(this._zodiacMainCubit)
      : super(const TransparrentAppBarState());

  void clearErrorMessage() {
    _zodiacMainCubit.clearErrorMessage();
  }
}
