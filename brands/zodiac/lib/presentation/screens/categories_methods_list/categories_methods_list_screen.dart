import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:zodiac/presentation/common_widgets/appbar/wide_app_bar.dart';
import 'package:zodiac/presentation/common_widgets/buttons/app_icon_button.dart';
import 'package:zodiac/presentation/common_widgets/checkbox_tile_widget.dart';
import 'package:zodiac/presentation/screens/categories_methods_list/categories_methods_list_cubit.dart';

class CategoriesMethodsListScreen extends StatelessWidget {
  final String title;
  final List<CategoriesMethodsListItem> items;
  final int? initialSelectedId;
  final ValueSetter<int> returnCallback;

  const CategoriesMethodsListScreen({
    Key? key,
    required this.title,
    required this.items,
    required this.returnCallback,
    this.initialSelectedId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return BlocProvider(
      create: (context) => CategoriesMethodsListCubit(initialSelectedId),
      child: Builder(builder: (context) {
        final int? selectedId = context.select(
            (CategoriesMethodsListCubit cubit) => cubit.state.selectedId);
        return Scaffold(
          backgroundColor: theme.canvasColor,
          appBar: WideAppBar(
            bottomWidget: Text(
              title,
              style: theme.textTheme.headlineMedium,
            ),
            topRightWidget: selectedId != null
                ? AppIconButton(
                    icon: Assets.vectors.check.path,
                    onTap: () {
                      context.pop();
                      returnCallback(selectedId);
                    },
                  )
                : null,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.horizontalScreenPadding,
                vertical: 8.0),
            child: ListView.builder(
              itemBuilder: (context, index) => CheckboxTileWidget(
                  isMultiselect: false,
                  isSelected: items[index].id == selectedId,
                  title: items[index].name,
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    context
                        .read<CategoriesMethodsListCubit>()
                        .selectItem(items[index].id);
                  }),
              itemCount: items.length,
            ),
          ),
        );
      }),
    );
  }
}

class CategoriesMethodsListItem {
  final int id;
  final String name;

  CategoriesMethodsListItem({
    required this.id,
    required this.name,
  });
}
