import 'package:emoji_picker_flutter/emoji_picker_flutter.dart'
    hide EmojiPickerState;
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

  Future<void> searchEmojiByName(String value) async {
    if (value.isNotEmpty) {
      final List<Emoji> emojis =
          await EmojiPickerUtils().searchEmoji(value, defaultEmojiSet);

      emit(state.copyWith(searchedEmojis: emojis));
    } else {
      emit(state.copyWith(searchedEmojis: []));
    }
  }

  void setSearchFocused(bool value) {
    emit(state.copyWith(searchFieldFocused: value));
    if (!value && state.searchedEmojis.isEmpty) {
      emit(state.copyWith(categoryIndex: 0));
    }
  }
}
