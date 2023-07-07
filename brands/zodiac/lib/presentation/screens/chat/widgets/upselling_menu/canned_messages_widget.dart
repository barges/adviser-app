import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:zodiac/data/models/canned_message/canned_message_category.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/screens/chat/chat_cubit.dart';
import 'package:zodiac/presentation/screens/chat/widgets/upselling_menu/category_menu_item_widget.dart';

class CannedMessagesWidget extends StatefulWidget {
  const CannedMessagesWidget({Key? key}) : super(key: key);

  @override
  State<CannedMessagesWidget> createState() => _CannedMessagesWidgetState();
}

class _CannedMessagesWidgetState extends State<CannedMessagesWidget> {
  int selectedCategotyIndex = 0;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final List<CannedMessageCategory>? cannedMessageCategories = context
        .select((ChatCubit cubit) => cubit.state.cannedMessageCategories);
    if (cannedMessageCategories != null) {
      return Container(
          decoration: BoxDecoration(color: theme.canvasColor),
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.horizontalScreenPadding),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 32.0,
                    ),
                    Expanded(
                      child: Text(
                        SZodiac.of(context).sendCannedMessageZodiac,
                        style: theme.textTheme.headlineMedium
                            ?.copyWith(fontSize: 17.0),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      width: 8.0,
                    ),
                    Assets.zodiac.vectors.crossSmall.svg(
                      height: AppConstants.iconSize,
                      width: AppConstants.iconSize,
                      colorFilter: ColorFilter.mode(
                        theme.shadowColor,
                        BlendMode.srcIn,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 12.0,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    const SizedBox(
                      width: AppConstants.horizontalScreenPadding,
                    ),
                    ...cannedMessageCategories.mapIndexed((index, element) {
                      final Widget child = CategotyMenuItemWidget(
                        title: element.categoryName ?? '',
                        isSelected: selectedCategotyIndex == index,
                        onTap: () {
                          if (selectedCategotyIndex != index) {
                            setState(() {
                              selectedCategotyIndex = index;
                            });
                          }
                        },
                      );
                      if (index != cannedMessageCategories.length - 1) {
                        return Row(
                          children: [
                            child,
                            const SizedBox(
                              width: 8.0,
                            )
                          ],
                        );
                      } else {
                        return child;
                      }
                    }).toList(),
                    const SizedBox(
                      width: AppConstants.horizontalScreenPadding,
                    ),
                  ],
                ),
              )
            ],
          ));
    } else {
      return const SizedBox.shrink();
    }
  }
}
