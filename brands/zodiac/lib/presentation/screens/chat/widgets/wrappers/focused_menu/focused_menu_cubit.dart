import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:zodiac/presentation/screens/chat/widgets/wrappers/focused_menu/focused_menu_state.dart';

class FocusedMenuCubit extends Cubit<FocusedMenuState> {
  FocusedMenuCubit() : super(const FocusedMenuState()) {
    _getRecentEmojis();
  }

  Future<void> _getRecentEmojis() async {
    final recentEmojis = await EmojiPickerUtils().getRecentEmojis();

    final List<Emoji> emojisList = recentEmojis.map((e) => e.emoji).toList();

    logger.d(emojisList);

    emit(state.copyWith(recentEmojis: emojisList));
  }
}
