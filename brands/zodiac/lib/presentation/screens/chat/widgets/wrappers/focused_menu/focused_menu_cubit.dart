import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zodiac/presentation/screens/chat/widgets/wrappers/focused_menu/focused_menu_state.dart';

class FocusedMenuCubit extends Cubit<FocusedMenuState> {
  final String selectedReaction;
  FocusedMenuCubit(this.selectedReaction) : super(const FocusedMenuState()) {
    _getRecentEmojis();
  }

  Future<void> _getRecentEmojis() async {

      final recentEmojis = await EmojiPickerUtils().getRecentEmojis();

      final List<Emoji> emojisList = [];

      if (selectedReaction.isNotEmpty) {
        emojisList.add(Emoji(selectedReaction, ''));
        recentEmojis.removeWhere(
          (element) => element.emoji.emoji == selectedReaction,
        );
        emojisList.addAll(recentEmojis.take(5).map((e) => e.emoji));
      } else {
        emojisList.addAll(recentEmojis.take(6).map((e) => e.emoji));
      }
        if(!isClosed) {
          emit(state.copyWith(recentEmojis: emojisList));
        }

  }
}
