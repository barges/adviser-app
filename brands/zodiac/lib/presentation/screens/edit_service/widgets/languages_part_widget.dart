import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zodiac/presentation/common_widgets/service/service_languages_widget.dart';
import 'package:zodiac/presentation/screens/edit_service/edit_service_cubit.dart';

class LanguagesPartWidget extends StatelessWidget {
  final List<String> languagesList;

  const LanguagesPartWidget({
    Key? key,
    required this.languagesList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final EditServiceCubit editServiceCubit = context.read<EditServiceCubit>();

    final int selectedLanguageIndex = context
        .select((EditServiceCubit cubit) => cubit.state.selectedLanguageIndex);
    final int? mainLanguageIndex = context
        .select((EditServiceCubit cubit) => cubit.state.mainLanguageIndex);

    return Column(
      children: [
        ServiceLanguagesWidget(
          languagesList: languagesList,
          languagesGlobalKeys: editServiceCubit.languagesGlobalKeys,
          titleFormatter: editServiceCubit.localeNativeName,
          selectedLanguageIndex: selectedLanguageIndex,
          mainLanguageIndex: mainLanguageIndex,
          deleteEnabled: false,
          setIsSelected: editServiceCubit.changeLocaleIndex,
        )
      ],
    );
  }
}
