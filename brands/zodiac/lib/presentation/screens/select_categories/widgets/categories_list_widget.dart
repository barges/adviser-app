import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zodiac/data/models/user_info/category_info.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/screens/select_categories/select_categories_cubit.dart';
import 'package:zodiac/presentation/screens/select_categories/widgets/category_item_widget.dart';

class CategoriesListWidget extends StatelessWidget {
  final List<CategoryInfo> categories;

  const CategoriesListWidget({
    Key? key,
    required this.categories,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final SelectCategoriesCubit categoriesListCubit =
        context.read<SelectCategoriesCubit>();

    final List<int> selectedIds = context
        .select((SelectCategoriesCubit cubit) => cubit.state.selectedIds);

    return Container(
      decoration: BoxDecoration(
        color: theme.canvasColor,
        borderRadius: BorderRadius.circular(12.0),
      ),
      padding: const EdgeInsets.only(top: 20.0, bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      SZodiac.of(context).categoriesZodiac,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontSize: 17.0,
                      ),
                    ),
                    const SizedBox(
                      width: 4.0,
                    ),
                    Container(
                      padding: const EdgeInsets.all(2.0),
                      decoration: BoxDecoration(
                        color: theme.primaryColor,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        '${selectedIds.length}/$maxCategoriesCount',
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontSize: 13.0,
                          color: theme.canvasColor,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 12.0,
                ),
                Text(
                  SZodiac.of(context).youCanChooseUpTo3CategoriesZodiac,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.shadowColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 16.0,
          ),
          SizedBox(
            height: 148.0,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: [
                const SizedBox(
                  width: 16.0,
                ),
                ...categories
                    .mapIndexed(
                      (i, e) => Padding(
                        padding: EdgeInsets.only(
                            right: i != categories.length - 1 ? 8.0 : 0.0),
                        child: GestureDetector(
                          onTap: () =>
                              categoriesListCubit.onCategorySelectChange(e.id),
                          child: CategoryItemWidget(
                            image: e.image,
                            icon: e.icon,
                            name: e.name,
                            isSelected: selectedIds.contains(e.id),
                            maxCountReached:
                                selectedIds.length == maxCategoriesCount,
                          ),
                        ),
                      ),
                    )
                    .toList(),
                const SizedBox(
                  width: 16.0,
                ),
              ]),
            ),
          )
        ],
      ),
    );
  }
}
