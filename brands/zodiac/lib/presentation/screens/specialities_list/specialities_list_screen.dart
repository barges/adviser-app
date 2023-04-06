import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_icon_button.dart';
import 'package:zodiac/data/cache/zodiac_caching_manager.dart';
import 'package:zodiac/data/models/user_info/category_info.dart';
import 'package:zodiac/domain/repositories/zodiac_user_repository.dart';
import 'package:zodiac/infrastructure/di/inject_config.dart';
import 'package:zodiac/presentation/common_widgets/appbar/wide_app_bar.dart';
import 'package:zodiac/presentation/common_widgets/checkbox_tile_widget.dart';
import 'package:zodiac/presentation/screens/specialities_list/specialities_list_cubit.dart';

class SpecialitiesListScreen extends StatelessWidget {
  final List<CategoryInfo> oldSelectedCategories;
  final ValueChanged<List<CategoryInfo>> returnCallback;
  final bool isMultiselect;

  const SpecialitiesListScreen({
    Key? key,
    required this.oldSelectedCategories,
    required this.returnCallback,
    this.isMultiselect = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => SpecialitiesListCubit(
              zodiacGetIt.get<ZodiacUserRepository>(),
              zodiacGetIt.get<ZodiacCachingManager>(),
              oldSelectedCategories,
              isMultiselect,
            ),
        child: Builder(builder: (context) {
          final SpecialitiesListCubit specialitiesListCubit =
              context.read<SpecialitiesListCubit>();

          return Scaffold(
            backgroundColor: Theme.of(context).canvasColor,
            appBar: WideAppBar(
              bottomWidget: Text(
                isMultiselect ? 'All specialities' : 'Main speciality',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              topRightWidget: AppIconButton(
                icon: Assets.vectors.check.path,
                onTap: () {
                  context.pop();
                  returnCallback(
                      specialitiesListCubit.state.selectedCategories);
                },
              ),
            ),
            body: Builder(builder: (context) {
              final List<CategoryInfo> categories = context.select(
                  (SpecialitiesListCubit cubit) => cubit.state.categories);
              final List<CategoryInfo> selectedCategories = context.select(
                  (SpecialitiesListCubit cubit) =>
                      cubit.state.selectedCategories);
              return SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  AppConstants.horizontalScreenPadding,
                  8.0,
                  AppConstants.horizontalScreenPadding,
                  MediaQuery.of(context).padding.bottom + 8,
                ),
                child: Column(
                  children: categories.mapIndexed((index, element) {
                    return CheckboxTileWidget(
                      isMultiselect: isMultiselect,
                      isSelected: selectedCategories.any((e) => e.id == element.id),
                      title: element.name ?? '',
                      onTap: () => specialitiesListCubit.tapToCategory(index),
                    );
                  }).toList(),
                ),
              );
            }),
          );
        }));
  }
}
