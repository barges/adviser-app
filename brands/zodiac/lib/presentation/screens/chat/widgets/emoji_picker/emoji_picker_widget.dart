import 'package:collection/collection.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zodiac/presentation/screens/chat/widgets/emoji_picker/emoji_picker_cubit.dart';

class EmojiPickerWidget extends StatelessWidget {
  const EmojiPickerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return BlocProvider(
        create: (context) => EmojiPickerCubit(),
        child: Builder(builder: (context) {
          final EmojiPickerCubit emojiPickerCubit =
              context.read<EmojiPickerCubit>();
          final int categoryIndex = context
              .select((EmojiPickerCubit cubit) => cubit.state.categoryIndex);
          return Container(
            height: 345,
            color: theme.canvasColor,
            padding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
            child: EmojiPicker(
              customWidget: (config, state) {
                final List<CategoryEmoji> categories = state.categoryEmoji;
                final List<Emoji> emojis = categories[categoryIndex].emoji;
                return Column(
                  children: [
                    Expanded(
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 40.0,
                                mainAxisSpacing: 10.0,
                                crossAxisSpacing: 10.0),
                        itemBuilder: (context, index) => Center(
                          child: Text(
                            emojis[index].emoji,
                            style: theme.textTheme.bodyMedium
                                ?.copyWith(fontSize: 30.0),
                          ),
                        ),
                        itemCount: emojis.length,
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: categories.mapIndexed((index, element) {
                            final bool isSelected = categoryIndex == index;
                            return GestureDetector(
                              onTap: () =>
                                  emojiPickerCubit.setCategoryIndex(index),
                              child: Container(
                                height: 32.0,
                                width: 32.0,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? theme.primaryColorLight
                                      : null,
                                  borderRadius: BorderRadius.circular(8.0),
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
                        )

                        // ListView.separated(
                        //     shrinkWrap: true,
                        //     scrollDirection: Axis.horizontal,
                        //     itemBuilder: (context, index) =>
                        //         Icon(categories[index].category.icon),
                        //     separatorBuilder: (context, index) =>
                        //         const SizedBox(width: 2.0),
                        //     itemCount: categories.length)),
                        )
                  ],
                );
              },
            ),
          );
        }));
  }
}

extension CategoryEmojiExt on Category {
  IconData get icon {
    switch (this) {
      case Category.RECENT:
        return CupertinoIcons.clock;
      case Category.SMILEYS:
        return CupertinoIcons.smiley;
      case Category.ANIMALS:
        return CupertinoIcons.paw;
      case Category.FOODS:
        return Icons.fastfood;
      case Category.ACTIVITIES:
        return Icons.directions_run;
      case Category.TRAVEL:
        return Icons.location_city;
      case Category.OBJECTS:
        return CupertinoIcons.lightbulb;
      case Category.SYMBOLS:
        return CupertinoIcons.heart;
      case Category.FLAGS:
        return CupertinoIcons.flag;
    }
  }
}
