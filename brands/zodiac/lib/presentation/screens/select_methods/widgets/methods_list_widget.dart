import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zodiac/data/models/user_info/category_info.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/screens/select_methods/select_methods_cubit.dart';
import 'package:zodiac/presentation/screens/select_methods/widgets/method_item.dart';

class MethodsListWidget extends StatelessWidget {
  final List<CategoryInfo> methods;
  const MethodsListWidget({
    Key? key,
    required this.methods,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final SelectMethodsCubit selectMethodsCubit =
        context.read<SelectMethodsCubit>();

    final List<int> selectedIds =
        context.select((SelectMethodsCubit cubit) => cubit.state.selectedIds);

    return Container(
      padding: EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: theme.canvasColor,
      ),
      child: Column(children: [
        Row(
          children: [
            Text(
              SZodiac.of(context).methodsZodiac,
              style: theme.textTheme.headlineMedium?.copyWith(fontSize: 17.0),
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
                '${selectedIds.length}/$maxMethodsCount',
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
        const SizedBox(
          height: 16.0,
        ),
        ListView.separated(
          shrinkWrap: true,
          itemBuilder: (context, index) => MethodItem(
            title: methods[index].name ?? '',
            isSelected: selectedIds.contains(methods[index].id),
            onTap: () =>
                selectMethodsCubit.onMethodSelectChange(methods[index].id),
            limitReached: selectedIds.length >= maxMethodsCount,
          ),
          separatorBuilder: (context, index) => const SizedBox(height: 12.0),
          itemCount: methods.length,
        )
      ]),
    );
  }
}
