import 'package:zodiac/presentation/base_cubit/base_cubit.dart';
import 'package:zodiac/presentation/screens/chat/widgets/upselling_menu/coupons/coupons_state.dart';
import 'package:zodiac/services/websocket_manager/websocket_manager.dart';

class CouponsCubit extends BaseCubit<CouponsState> {
  final WebSocketManager _webSocketManager;
  final int? _opponentId;

  int selectedMessageIndex = 1;

  CouponsCubit(this._webSocketManager, this._opponentId)
      : super(const CouponsState()) {
    addListener(_webSocketManager.sendUserMessageStream.listen((event) {
      if (event.opponentId == _opponentId) {
        emit(state.copyWith(errorMessage: event.message));
      }
    }));
  }

  void setSelectedCategoryIndex(int index) {
    emit(state.copyWith(selectedCategoryIndex: index));
  }

  void onPageChanged(int index) {
    selectedMessageIndex = index;
  }
}
