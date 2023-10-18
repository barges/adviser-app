import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/appbars/simple_app_bar.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_elevated_button.dart';
import 'package:zodiac/data/models/user_info/category_info.dart';
import 'package:zodiac/domain/repositories/zodiac_edit_profile_repository.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/infrastructure/di/inject_config.dart';
import 'package:zodiac/presentation/screens/select_categories/select_categories_cubit.dart';
import 'package:zodiac/presentation/screens/select_categories/widgets/categories_list_widget.dart';
import 'package:zodiac/presentation/screens/edit_profile/widgets/tile_menu_button.dart';

class SelectCategoriesScreen extends StatelessWidget {
  final List<int> selectedCategoryIds;
  final int? mainCategoryId;
  final Function(List<CategoryInfo>, int) returnCallback;

  const SelectCategoriesScreen({
    Key? key,
    required this.selectedCategoryIds,
    required this.returnCallback,
    this.mainCategoryId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return BlocProvider(
      create: (context) => SelectCategoriesCubit(
        selectedCategoryIds,
        mainCategoryId,
        returnCallback,
        zodiacGetIt.get<ZodiacEditProfileRepository>(),
      ),
      child: Builder(builder: (context) {
        final SelectCategoriesCubit categoriesListCubit =
            context.read<SelectCategoriesCubit>();

        return Scaffold(
          appBar: SimpleAppBar(
            title: SZodiac.of(context).selectCategoriesZodiac,
          ),
          body: Builder(builder: (context) {
            final List<CategoryInfo>? categories = context.select(
                (SelectCategoriesCubit cubit) => cubit.state.categories);

            if (categories != null) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: AppConstants.horizontalScreenPadding,
                  ),
                  child: Column(
                    children: [
                      CategoriesListWidget(
                        categories: categories,
                      ),
                      const SizedBox(
                        height: 24.0,
                      ),
                      Builder(builder: (context) {
                        final List<int> selectedIds = context.select(
                            (SelectCategoriesCubit cubit) =>
                                cubit.state.selectedIds);

                        final int? mainCategoryId = context.select(
                            (SelectCategoriesCubit cubit) =>
                                cubit.state.mainCategoryId);

                        final bool mainCategoryIsNull = mainCategoryId == null;
                        final bool selectedIdsEmpty = selectedIds.isEmpty;

                        return TileMenuButton(
                          label: SZodiac.of(context).mainCategoryZodiac,
                          title: selectedIdsEmpty
                              ? SZodiac.of(context)
                                  .firstSelectTheCategoriesZodiac
                              : !mainCategoryIsNull
                                  ? categories
                                          .firstWhere((element) =>
                                              element.id == mainCategoryId)
                                          .name ??
                                      ''
                                  : SZodiac.of(context)
                                      .selectMainCategoryZodiac,
                          onTap: () =>
                              categoriesListCubit.selectMainCategory(context),
                          titleColor: mainCategoryIsNull || selectedIdsEmpty
                              ? theme.shadowColor
                              : null,
                          labelColor:
                              selectedIdsEmpty ? theme.shadowColor : null,
                          backgroundColor: selectedIdsEmpty
                              ? theme.scaffoldBackgroundColor
                              : null,
                        );
                      })
                    ],
                  ),
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          }),
          bottomNavigationBar: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.horizontalScreenPadding,
                vertical: 12.0,
              ),
              child: Builder(builder: (context) {
                final int? mainCategoryId = context.select(
                    (SelectCategoriesCubit cubit) =>
                        cubit.state.mainCategoryId);

                return AppElevatedButton(
                  title: SZodiac.of(context).saveZodiac,
                  onPressed: mainCategoryId != null
                      ? () => categoriesListCubit.saveChanges(context)
                      : null,
                );
              }),
            ),
          ),
        );
      }),
    );
  }
}
