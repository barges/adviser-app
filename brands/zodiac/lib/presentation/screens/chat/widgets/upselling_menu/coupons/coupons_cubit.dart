import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zodiac/presentation/screens/chat/widgets/upselling_menu/coupons/coupons_state.dart';

class CouponsCubit extends Cubit<CouponsState> {
  CouponsCubit() : super(const CouponsState());

  void setSelectedCategoryIndex(int index) {
    emit(state.copyWith(selectedCategoryIndex: index));
  }
}
