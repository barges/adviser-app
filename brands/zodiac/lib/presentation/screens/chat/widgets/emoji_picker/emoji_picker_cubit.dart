import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zodiac/presentation/screens/chat/widgets/emoji_picker/emoji_picker_state.dart';

class EmojiPickerCubit extends Cubit<EmojiPickerState> {
  final PageController categoriesPageController = PageController();

  EmojiPickerCubit() : super(const EmojiPickerState());

  void setCategoryIndex(int index, {bool shouldJump = false}) {
    emit(state.copyWith(categoryIndex: index));
    if (shouldJump) {
      categoriesPageController.jumpToPage(index);
    }
  }
}
