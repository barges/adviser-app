import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zodiac/data/models/user_info/category_info.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/screens/edit_profile/widgets/tile_menu_button.dart';
import 'package:zodiac/presentation/screens/select_methods/select_methods_cubit.dart';

class MainMethodButton extends StatelessWidget {
  final List<CategoryInfo> methods;
  const MainMethodButton({
    Key? key,
    required this.methods,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final SelectMethodsCubit selectMethodsCubit =
        context.read<SelectMethodsCubit>();

    final (List<int> selectedIds, int? mainMethodId) = context.select(
        (SelectMethodsCubit cubit) =>
            (cubit.state.selectedIds, cubit.state.mainMethodId));

    final bool mainMethodIsNull = mainMethodId == null;
    final bool selectedIdsEmpty = selectedIds.isEmpty;

    return TileMenuButton(
      label: SZodiac.of(context).mainMethodZodiac,
      title: selectedIdsEmpty
          ? SZodiac.of(context).firstSelectTheMethodsZodiac
          : !mainMethodIsNull
              ? methods
                      .firstWhere((element) => element.id == mainMethodId)
                      .name ??
                  ''
              : SZodiac.of(context).selectMainMethodZodiac,
      onTap: () => selectMethodsCubit.selectMainMethod(context),
      titleColor:
          mainMethodIsNull || selectedIdsEmpty ? theme.shadowColor : null,
      labelColor: selectedIdsEmpty ? theme.shadowColor : null,
      backgroundColor: selectedIdsEmpty ? theme.scaffoldBackgroundColor : null,
    );
  }
}
