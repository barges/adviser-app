import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zodiac/data/models/enums/validation_error_type.dart';
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
            ValueListenableBuilder(
                valueListenable: addServiceCubit
                    .hasFocusNotifiersMap[entry.key]![titleIndex],
                builder: (context, value, child) {
                  return AppTextField(
                    controller: entry.value[titleIndex],
                    focusNode:
                        addServiceCubit.focusNodesMap[entry.key]![titleIndex],
                    label: SZodiac.of(context).titleZodiac,
                    hintText: SZodiac.of(context).egAstrologyReadingZodiac,
                    maxLength: 40,
                    errorType: addServiceCubit.errorTextsMap[entry.key]
                            ?[titleIndex] ??
                        ValidationErrorType.empty,
                  );
                }),
            const SizedBox(
              height: 24.0,
            ),
            ValueListenableBuilder(
                valueListenable: addServiceCubit
                    .hasFocusNotifiersMap[entry.key]![titleIndex],
                builder: (context, value, child) {
                  return AppTextField(
                    controller: entry.value[descriptionIndex],
                    focusNode: addServiceCubit
                        .focusNodesMap[entry.key]![descriptionIndex],
                    isBig: true,
                    label: SZodiac.of(context).descriptionZodiac,
                    hintText: SZodiac.of(context).serviceDescriptionHintZodiac,
                    maxLength: 280,
                    showCounter: true,
                    footerHint: SZodiac.of(context)
                        .explainIn3to5StepsWhatTheCustomersWillGetZodiac,
                    errorType: addServiceCubit.errorTextsMap[entry.key]
                            ?[descriptionIndex] ??
                        ValidationErrorType.empty,
                  );
                }),
          ],
        );
      }).toList(),
    );
  }
}
