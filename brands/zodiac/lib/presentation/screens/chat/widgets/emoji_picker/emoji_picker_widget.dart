import 'package:collection/collection.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/common_widgets/search_widget.dart';
import 'package:zodiac/presentation/screens/chat/chat_cubit.dart';
import 'package:zodiac/presentation/screens/chat/widgets/emoji_picker/category_emoji_extension.dart';
import 'package:zodiac/presentation/screens/chat/widgets/emoji_picker/emoji_picker_cubit.dart';

class EmojiPickerWidget extends StatefulWidget {
  final String reactionMessageId;
  const EmojiPickerWidget({
    Key? key,
    required this.reactionMessageId,
  }) : super(key: key);

  @override
  State<EmojiPickerWidget> createState() => _EmojiPickerWidgetState();
}

class _EmojiPickerWidgetState extends State<EmojiPickerWidget> {
  final GlobalKey<EmojiPickerState> emojiPickerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ChatCubit chatCubit = context.read<ChatCubit>();

    return BlocProvider(
      create: (context) => EmojiPickerCubit(),
      child: Builder(
        builder: (context) {
          final EmojiPickerCubit emojiPickerCubit =
              context.read<EmojiPickerCubit>();

          final int categoryIndex = context
              .select((EmojiPickerCubit cubit) => cubit.state.categoryIndex);
          final List<Emoji> searchedEmojis = context
              .select((EmojiPickerCubit cubit) => cubit.state.searchedEmojis);
          final bool searchFieldEmpty = context
              .select((EmojiPickerCubit cubit) => cubit.state.searchFieldEmpty);

          return Container(
            color: theme.canvasColor,
            padding: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 8.0),
            child: EmojiPicker(
              customWidget: (config, state) {
                final List<CategoryEmoji> categories = state.categoryEmoji;

                return Column(
                  children: [
                    SearchWidget(
                      onChanged: emojiPickerCubit.searchEmojiByName,
                      onCancel: () => chatCubit.setEmojiPickerOpened(null),
                      backgroundColor: theme.scaffoldBackgroundColor,
                    ),
                    if (searchFieldEmpty)
                      SizedBox(
                        height: 302.0,
                        child: Column(
                          children: [
                            Expanded(
                              child: PageView.builder(
                                  controller:
                                      emojiPickerCubit.categoriesPageController,
                                  itemCount: categories.length,
                                  onPageChanged:
                                      emojiPickerCubit.setCategoryIndex,
                                  itemBuilder: (context, index) {
                                    final List<Emoji> emojis =
                                        categories[index].emoji;

                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              16.0, 12.0, 0.0, 8.0),
                                          child: Text(
                                            categories[index]
                                                .category
                                                .getTitle(context)
                                                .toUpperCase(),
                                            style: theme.textTheme.labelSmall
                                                ?.copyWith(
                                              fontSize: 11.0,
                                              color: theme.shadowColor,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: GridView.builder(
                                            gridDelegate:
                                                const SliverGridDelegateWithMaxCrossAxisExtent(
                                                    maxCrossAxisExtent: 40.0,
                                                    mainAxisSpacing: 10.0,
                                                    crossAxisSpacing: 10.0),
                                            itemBuilder: (context, index) =>
                                                GestureDetector(
                                              onTap: () {
                                                EmojiPickerUtils()
                                                    .addEmojiToRecentlyUsed(
                                                        key: emojiPickerKey,
                                                        emoji: emojis[index]);
                                                chatCubit.sendReaction(
                                                    widget.reactionMessageId,
                                                    emojis[index].emoji);
                                              },
                                              child: Center(
                                                child: Text(
                                                  emojis[index].emoji,
                                                  style: theme
                                                      .textTheme.bodyMedium
                                                      ?.copyWith(
                                                          fontSize: 30.0),
                                                ),
                                              ),
                                            ),
                                            itemCount: emojis.length,
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14.0),
                              child: SmoothPageIndicator(
                                controller:
                                    emojiPickerCubit.categoriesPageController,
                                count: categories.length,
                                effect: ScrollingDotsEffect(
                                  activeDotColor: theme.primaryColor,
                                  activeDotScale: 1.0,
                                  dotColor: theme.hintColor,
                                  maxVisibleDots: 5,
                                  dotHeight: 8.0,
                                  dotWidth: 8.0,
                                ),
                              ),
                            ),
                            Container(
                              height: 40.0,
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.all(4.0),
                              decoration: BoxDecoration(
                                color: theme.scaffoldBackgroundColor,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children:
                                    categories.mapIndexed((index, element) {
                                  final bool isSelected =
                                      categoryIndex == index;
                                  return GestureDetector(
                                    onTap: () =>
                                        emojiPickerCubit.setCategoryIndex(index,
                                            shouldJump: true),
                                    child: Container(
                                      height: 32.0,
                                      width: 32.0,
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? theme.primaryColorLight
                                            : null,
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      child: Icon(
                                        element.category.icon,
                                        color: isSelected
                                            ? theme.primaryColor
                                            : theme.shadowColor,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            )
                          ],
                        ),
                      )
                    else
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(16.0, 12.0, 0.0, 8.0),
                            child: Text(
                              SZodiac.of(context)
                                  .searchResultsZodiac
                                  .toUpperCase(),
                              style: theme.textTheme.labelSmall?.copyWith(
                                fontSize: 11.0,
                                color: theme.shadowColor,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 40.0,
                            child: searchedEmojis.isNotEmpty
                                ? ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: searchedEmojis.length,
                                    itemBuilder: (context, index) =>
                                        GestureDetector(
                                      onTap: () {
                                        EmojiPickerUtils()
                                            .addEmojiToRecentlyUsed(
                                                key: emojiPickerKey,
                                                emoji: searchedEmojis[index]);
                                        chatCubit.sendReaction(
                                            widget.reactionMessageId,
                                            searchedEmojis[index].emoji);
                                      },
                                      child: SizedBox(
                                        height: 40.0,
                                        width: 40.0,
                                        child: Center(
                                          child: Text(
                                            searchedEmojis[index].emoji,
                                            style: theme.textTheme.bodyMedium
                                                ?.copyWith(fontSize: 30.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(
                                      width: 10.0,
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        SZodiac.of(context).noEmojiFoundZodiac,
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                                color: theme.shadowColor),
                                      ),
                                    ],
                                  ),
                          ),
                        ],
                      ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
