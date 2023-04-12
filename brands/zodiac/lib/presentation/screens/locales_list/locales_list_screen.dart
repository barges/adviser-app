import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_icon_button.dart';
import 'package:zodiac/data/cache/zodiac_caching_manager.dart';
import 'package:zodiac/data/models/user_info/locale_model.dart';
import 'package:zodiac/domain/repositories/zodiac_user_repository.dart';
import 'package:zodiac/infrastructure/di/inject_config.dart';
import 'package:zodiac/presentation/common_widgets/appbar/wide_app_bar.dart';
import 'package:zodiac/presentation/common_widgets/checkbox_tile_widget.dart';
import 'package:zodiac/presentation/screens/locales_list/locales_list_cubit.dart';
import 'package:zodiac/presentation/screens/locales_list/widgets/search_widget.dart';

class LocalesListScreen extends StatelessWidget {
  final ValueChanged<String> returnCallback;
  final String title;
  final String? oldSelectedLocaleCode;
  final List<String>? unnecessaryLocalesCodes;

  const LocalesListScreen({
    Key? key,
    required this.returnCallback,
    required this.title,
    this.oldSelectedLocaleCode,
    this.unnecessaryLocalesCodes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => LocalesListCubit(
              zodiacGetIt.get<ZodiacUserRepository>(),
              zodiacGetIt.get<ZodiacCachingManager>(),
              oldSelectedLocaleCode,
              unnecessaryLocalesCodes: unnecessaryLocalesCodes,
            ),
        child: Builder(builder: (context) {
          final LocalesListCubit localesListCubit =
              context.read<LocalesListCubit>();

          final String? selectedLocaleCode = context.select(
              (LocalesListCubit cubit) => cubit.state.selectedLocaleCode);
          return GestureDetector(
            onTap: FocusScope.of(context).unfocus,
            child: Scaffold(
              backgroundColor: Theme.of(context).canvasColor,
              appBar: WideAppBar(
                bottomWidget: Text(
                  title,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                topRightWidget: selectedLocaleCode != null
                    ? AppIconButton(
                        icon: Assets.vectors.check.path,
                        onTap: () {
                          context.pop();
                          returnCallback(selectedLocaleCode);
                        },
                      )
                    : null,
              ),
              body: Column(
                children: [
                  SearchWidget(
                    onChanged: localesListCubit.search,
                  ),
                  Builder(builder: (context) {
                    final List<LocaleModel> locales = context.select(
                        (LocalesListCubit cubit) => cubit.state.locales);
                    return Expanded(
                      child: ListView(
                        padding: EdgeInsets.fromLTRB(
                          AppConstants.horizontalScreenPadding,
                          8.0,
                          AppConstants.horizontalScreenPadding,
                          MediaQuery.of(context).padding.bottom + 8,
                        ),
                        children: locales.mapIndexed((index, element) {
                          return CheckboxTileWidget(
                              isMultiselect: false,
                              isSelected: element.code == selectedLocaleCode,
                              title: element.nameNative ?? '',
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                localesListCubit.tapToLocale(index);
                              });
                        }).toList(),
                      ),
                    );
                  }),
                ],
              ),
            ),
          );
        }));
  }
}
