import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/appbars/simple_app_bar.dart';
import 'package:zodiac/data/models/user_info/category_info.dart';
import 'package:zodiac/domain/repositories/zodiac_edit_profile_repository.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/infrastructure/di/inject_config.dart';
import 'package:zodiac/presentation/screens/categories_list/categories_list_cubit.dart';
import 'package:zodiac/presentation/screens/categories_list/widgets/categories_list_widget.dart';

class CategoriesListScreen extends StatelessWidget {
  final List<int> selectedCategoryIds;

  const CategoriesListScreen({
    Key? key,
    required this.selectedCategoryIds,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CategoriesListCubit(
        selectedCategoryIds,
        zodiacGetIt.get<ZodiacEditProfileRepository>(),
      ),
      child: Scaffold(
        appBar: SimpleAppBar(
          title: SZodiac.of(context).selectCategoriesZodiac,
        ),
        body: Builder(builder: (context) {
          final List<CategoryInfo>? categories = context
              .select((CategoriesListCubit cubit) => cubit.state.categories);

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
                  ],
                ),
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        }),
      ),
    );
  }
}
