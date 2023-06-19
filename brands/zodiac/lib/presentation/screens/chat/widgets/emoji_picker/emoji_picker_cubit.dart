import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zodiac/presentation/screens/chat/widgets/emoji_picker/emoji_picker_state.dart';

class EmojiPickerCubit extends Cubit<EmojiPickerState> {
  EmojiPickerCubit() : super(const EmojiPickerState());

  void setCategoryIndex(int index) {
    emit(state.copyWith(categoryIndex: index));
  }
}
