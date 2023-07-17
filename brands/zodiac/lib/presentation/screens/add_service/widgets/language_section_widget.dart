import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:zodiac/data/models/services/service_language_model.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/common_widgets/checkbox_widget.dart';
import 'package:zodiac/presentation/screens/add_service/add_service_cubit.dart';

class LanguageSectionWidget extends StatelessWidget {
  const LanguageSectionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<ServiceLanguageModel>? languagesList =
        context.select((AddServiceCubit cubit) => cubit.state.languagesList);
    final int selectedLanguageIndex = context
        .select((AddServiceCubit cubit) => cubit.state.selectedLanguageIndex);

    if (languagesList != null) {
      return Column(
        children: [
          SizedBox(
            height: 18 + 20,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemBuilder: (context, index) => _LanguageButton(
                  languageModel: languagesList[index],
                  isSelected: selectedLanguageIndex == index),
              separatorBuilder: (context, index) => const SizedBox(width: 8.0),
              itemCount: languagesList.length,
            ),
          ),
          const SizedBox(
            height: 8.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 9.0,
            ),
            child: Row(
              children: [
                CheckboxWidget(
                  value: languagesList[selectedLanguageIndex].isMain,
                  onChanged: (value) {},
                ),
                const SizedBox(
                  width: 16.0,
                ),
                Text(SZodiac.of(context).setAsMainLanguageZodiac,
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(fontSize: 16.0))
              ],
            ),
          )
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}

class _LanguageButton extends StatelessWidget {
  final ServiceLanguageModel languageModel;
  final bool isSelected;

  const _LanguageButton({
    Key? key,
    required this.languageModel,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: isSelected ? theme.primaryColorLight : theme.canvasColor,
        borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 9.0),
      child: Row(children: [
        Text(
          languageModel.title ?? '',
          style: isSelected
              ? theme.textTheme.labelMedium
                  ?.copyWith(fontSize: 15.0, color: theme.primaryColor)
              : theme.textTheme.bodyMedium,
        ),
        if (languageModel.isMain)
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.0),
              color: theme.scaffoldBackgroundColor,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
            child: Text(
              SZodiac.of(context).mainZodiac.toUpperCase(),
              style: theme.textTheme.labelSmall?.copyWith(
                fontSize: 12.0,
                color: theme.primaryColor,
              ),
            ),
          )
      ]),
    );
  }
}
