import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:zodiac/presentation/common_widgets/service/title_description_part_widget.dart';
import 'package:zodiac/presentation/screens/add_service/add_service_cubit.dart';
import 'package:zodiac/presentation/screens/add_service/widgets/language_section_widget.dart';

class LanguagesPartWidget extends StatelessWidget {
  final List<String> languagesList;
  const LanguagesPartWidget({
    Key? key,
    required this.languagesList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AddServiceCubit addServiceCubit = context.read<AddServiceCubit>();

    final int selectedLanguageIndex = context
        .select((AddServiceCubit cubit) => cubit.state.selectedLanguageIndex);

    return Column(
      children: [
        LanguageSectionWidget(
          selectedLanguageIndex: selectedLanguageIndex,
          languagesList: languagesList,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.horizontalScreenPadding,
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 24.0,
              ),
              Builder(builder: (context) {
                final bool update = context.select((AddServiceCubit cubit) =>
                    cubit.state.updateAfterDuplicate);

                return TitleDescriptionPartWidget(
                  key: ValueKey('UpdateTitleDescription$update'),
                  languagesList: languagesList,
                  selectedLanguageIndex: selectedLanguageIndex,
                  textControllersMap: addServiceCubit.textControllersMap,
                  hasFocusNotifiersMap: addServiceCubit.hasFocusNotifiersMap,
                  errorTextsMap: addServiceCubit.errorTextsMap,
                  focusNodesMap: addServiceCubit.focusNodesMap,
                );
              })
            ],
          ),
        )
      ],
    );
  }
}
