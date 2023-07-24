import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/common_widgets/text_fields/app_text_field.dart';
import 'package:zodiac/presentation/screens/add_service/add_service_cubit.dart';

class TitleDescriptionPartWidget extends StatelessWidget {
  final int selectedLanguageIndex;

  const TitleDescriptionPartWidget({
    Key? key,
    required this.selectedLanguageIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AddServiceCubit addServiceCubit = context.read<AddServiceCubit>();
    return IndexedStack(
      index: selectedLanguageIndex,
      children: addServiceCubit.textControllersMap.entries.map((entry) {
        return Column(
          children: [
            AppTextField(
              controller: entry.value[titleIndex],
              label: SZodiac.of(context).titleZodiac,
              hintText: SZodiac.of(context).egAstrologyReadingZodiac,
            ),
            const SizedBox(
              height: 24.0,
            ),
            AppTextField(
              controller: entry.value[descriptionIndex],
              isBig: true,
              label: SZodiac.of(context).descriptionZodiac,
              hintText: SZodiac.of(context).serviceDescriptionHintZodiac,
              maxLength: 280,
              showCounter: true,
              footerHint: SZodiac.of(context)
                  .explainIn3to5StepsWhatTheCustomersWillGetZodiac,
            ),
          ],
        );
      }).toList(),
    );
  }
}
