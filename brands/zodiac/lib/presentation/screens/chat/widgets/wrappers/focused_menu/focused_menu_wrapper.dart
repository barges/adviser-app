import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:shared_advisor_interface/themes/app_colors.dart';
import 'package:shared_advisor_interface/themes/app_colors_dark.dart';
import 'package:shared_advisor_interface/themes/app_colors_light.dart';
import 'package:shared_advisor_interface/utils/utils.dart';
import 'package:zodiac/data/models/chat/chat_message_model.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/screens/chat/chat_cubit.dart';
import 'package:zodiac/presentation/screens/chat/widgets/chat_message/chat_message_widget.dart';
import 'package:zodiac/presentation/screens/chat/widgets/chat_message/chat_message_widget_reply_wrapper.dart';
import 'package:zodiac/presentation/screens/chat/widgets/wrappers/focused_menu/focused_menu_cubit.dart';
import 'package:zodiac/presentation/screens/chat/widgets/wrappers/focused_menu/focused_menu_holder.dart';

class FocusedMenuWrapper extends StatefulWidget {
  final ChatMessageModel chatMessageModel;
  final bool chatIsActive;

  const FocusedMenuWrapper(
      {Key? key, required this.chatMessageModel, required this.chatIsActive})
      : super(key: key);

  @override
  State<FocusedMenuWrapper> createState() => _FocusedMenuWrapperState();
}

class _FocusedMenuWrapperState extends State<FocusedMenuWrapper> {
  final GlobalKey key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDarkMode = Utils.isDarkMode(context);
    final ChatCubit chatCubit = context.read<ChatCubit>();
    final bool supportsReaction =
        widget.chatMessageModel.supportsReaction == true;
    final bool supportsReply = widget.chatMessageModel.supportsReply == true;
    final bool focusedMenuEnabled =
        (supportsReaction || supportsReply) && widget.chatIsActive;

    if (focusedMenuEnabled) {
      return BlocProvider(
        create: (context) => FocusedMenuCubit(widget.chatMessageModel.reaction),
        child: Builder(builder: (context) {
          List<Emoji> recentEmojis = context
              .select((FocusedMenuCubit cubit) => cubit.state.recentEmojis);

          return FocusedMenuHolder(
            key: key,
            onPressed: () {},
            animateMenuItems: true,
            menuWidth: 244.0,
            menuOffset: 8.0,
            menuBorderRadius: 12.0,
            bottomOffsetHeight: 8.0,
            blurBackgroundColor:
                AppColors.overlay.withOpacity(isDarkMode ? 0.8 : 0.3),
            menuSeparator: Container(
              height: 8.0,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(
                  width: 1.0,
                  color: theme.shadowColor,
                )),
                color: isDarkMode
                    ? AppColorsDark.menuSeparator
                    : AppColorsLight.menuSeparator,
              ),
            ),
            menuItems: supportsReply
                ? [
                    FocusedMenuItem(
                      title: Text(
                        SZodiac.of(context).replyZodiac,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 17.0,
                        ),
                      ),
                      onPressed: () => chatCubit.setRepliedMessage(
                        repliedMessage: widget.chatMessageModel,
                      ),
                      backgroundColor: theme.unselectedWidgetColor,
                      trailingIcon: Assets.zodiac.vectors.arrowReply.svg(
                        height: AppConstants.iconSize,
                        width: AppConstants.iconSize,
                        color: theme.shadowColor,
                      ),
                    ),
                    FocusedMenuItem(
                      title: Text(
                        SZodiac.of(context).cancelZodiac,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 17.0,
                        ),
                      ),
                      backgroundColor: theme.unselectedWidgetColor,
                      trailingIcon: Assets.zodiac.vectors.crossSmall.svg(
                        height: AppConstants.iconSize,
                        width: AppConstants.iconSize,
                        color: theme.shadowColor,
                      ),
                    ),
                  ]
                : [],
            topMenuWidget: supportsReaction
                ? Builder(builder: (context) {
                    return Container(
                      height: 48.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: theme.canvasColor,
                      ),
                      padding: const EdgeInsets.all(4.0),
                      child: ListView.separated(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            if (recentEmojis.isNotEmpty &&
                                index != recentEmojis.length) {
                              return Builder(builder: (context) {
                                final bool isSelected =
                                    recentEmojis[index].emoji ==
                                        widget.chatMessageModel.reaction;
                                return GestureDetector(
                                  onTap: () {
                                    final String? messageId = _getMessageId();
                                    if (messageId != null) {
                                      chatCubit.sendReaction(
                                          messageId,
                                          isSelected
                                              ? ''
                                              : recentEmojis[index].emoji);
                                    }
                                    context.pop();
                                  },
                                  child: Container(
                                    height: 40.0,
                                    width: 40.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          isSelected ? 8.0 : 0.0),
                                      color: isSelected
                                          ? theme.primaryColorLight
                                          : null,
                                    ),
                                    child: Center(
                                      child: Text(
                                        recentEmojis[index].emoji,
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(fontSize: 30.0),
                                      ),
                                    ),
                                  ),
                                );
                              });
                            } else {
                              return GestureDetector(
                                onTap: () {
                                  chatCubit
                                      .setEmojiPickerOpened(_getMessageId());
                                  context.pop();
                                },
                                child: Container(
                                  height: 40.0,
                                  width: 40.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    color: theme.scaffoldBackgroundColor,
                                  ),
                                  child: Center(
                                    child: Assets.zodiac.vectors.selectEmojiIcon
                                        .svg(
                                      height: AppConstants.iconSize,
                                      width: AppConstants.iconSize,
                                      color: theme.shadowColor,
                                    ),
                                  ),
                                ),
                              );
                            }
                          },
                          separatorBuilder: (context, index) =>
                              const SizedBox(width: 8.0),
                          itemCount: recentEmojis.length + 1),
                    );
                  })
                : null,
            openedChild:
                ChatMessageWidget(chatMessageModel: widget.chatMessageModel),
            child: ChatMessageWidgetReplyWrapper(
              chatMessageModel: widget.chatMessageModel,
              chatIsActive: widget.chatIsActive,
            ),
          );
        }),
      );
    } else {
      return ChatMessageWidgetReplyWrapper(
        chatMessageModel: widget.chatMessageModel,
        chatIsActive: widget.chatIsActive,
      );
    }
  }

  String? _getMessageId() {
    final int? id = widget.chatMessageModel.id;
    final String? mid = widget.chatMessageModel.mid;
    return id != null ? id.toString() : mid;
  }
}
