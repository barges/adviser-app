import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zodiac/presentation/screens/chat/widgets/upselling_menu/canned_messages/canned_messages_state.dart';

class CannedMessagesCubit extends Cubit<CannedMessagesState> {
  int selectedMessageIndex = 0;
  String? editedCannedMessage;

  CannedMessagesCubit() : super(const CannedMessagesState());

  void setSelectedCategoryIndex(int index) {
    emit(state.copyWith(selectedCategoryIndex: index));
  }

  void onPageChanged(int index) {
    selectedMessageIndex = index;
    editedCannedMessage = null;
    emit(state.copyWith(editingCannedMessageIndex: null));
  }

  void setEditingIndex(int index) {
    emit(state.copyWith(editingCannedMessageIndex: index));
  }
}
