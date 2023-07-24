import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:zodiac/presentation/screens/add_service/add_service_cubit.dart';
import 'package:zodiac/presentation/screens/add_service/widgets/language_section_widget.dart';
import 'package:zodiac/presentation/screens/add_service/widgets/title_description_part_widget.dart';

class LanguagesPartWidget extends StatelessWidget {
  const LanguagesPartWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int selectedLanguageIndex = context
        .select((AddServiceCubit cubit) => cubit.state.selectedLanguageIndex);

    return Column(
      children: [
        LanguageSectionWidget(selectedLanguageIndex: selectedLanguageIndex),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.horizontalScreenPadding,
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 24.0,
              ),
              TitleDescriptionPartWidget(
                selectedLanguageIndex: selectedLanguageIndex,
              ),
            ],
          ),
        )
      ],
    );
  }
}
