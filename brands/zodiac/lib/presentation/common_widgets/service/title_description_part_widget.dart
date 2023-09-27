import 'package:flutter/material.dart';
import 'package:zodiac/data/models/enums/approval_status.dart';
import 'package:zodiac/data/models/enums/validation_error_type.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/common_widgets/text_fields/app_text_field.dart';
import 'package:zodiac/zodiac_constants.dart';

class TitleDescriptionPartWidget extends StatelessWidget {
  final int selectedLanguageIndex;
  final List<String> languagesList;
  final Map<String, List<TextEditingController>> textControllersMap;
  final Map<String, List<ValueNotifier>> hasFocusNotifiersMap;
  final Map<String, List<ValidationErrorType>> errorTextsMap;
  final Map<String, List<FocusNode>> focusNodesMap;
  final Map<String, List<ApprovalStatus?>>? approvalStatusMap;

  const TitleDescriptionPartWidget({
    Key? key,
    required this.selectedLanguageIndex,
    required this.languagesList,
    required this.textControllersMap,
    required this.hasFocusNotifiersMap,
    required this.errorTextsMap,
    required this.focusNodesMap,
    this.approvalStatusMap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: selectedLanguageIndex,
      children: languagesList.map((entry) {
        return Column(
          children: [
            ValueListenableBuilder(
                valueListenable: hasFocusNotifiersMap[entry]![
                    ZodiacConstants.serviceTitleIndex],
                builder: (context, value, child) {
                  return AppTextField(
                    controller: textControllersMap[entry]
                        ?[ZodiacConstants.serviceTitleIndex],
                    focusNode: focusNodesMap[entry]![
                        ZodiacConstants.serviceTitleIndex],
                    label: SZodiac.of(context).titleZodiac,
                    hintText: SZodiac.of(context).egAstrologyReadingZodiac,

                    ///TODO - Replace with backend value
                    maxLength: 40,
                    cutMaxLength: true,
                    errorType: errorTextsMap[entry]
                            ?[ZodiacConstants.serviceTitleIndex] ??
                        ValidationErrorType.empty,
                    approvalStatus: approvalStatusMap?[entry]
                        ?[ZodiacConstants.serviceTitleIndex],
                  );
                }),
            const SizedBox(
              height: 24.0,
            ),
            ValueListenableBuilder(
                valueListenable: hasFocusNotifiersMap[entry]![
                    ZodiacConstants.serviceDescriptionIndex],
                builder: (context, value, child) {
                  return AppTextField(
                    controller: textControllersMap[entry]
                        ?[ZodiacConstants.serviceDescriptionIndex],
                    focusNode: focusNodesMap[entry]![
                        ZodiacConstants.serviceDescriptionIndex],
                    isBig: true,
                    label: SZodiac.of(context).descriptionZodiac,
                    hintText: SZodiac.of(context).serviceDescriptionHintZodiac,

                    ///TODO - Replace with backend value
                    maxLength: ZodiacConstants.serviceDescriptionMaxLength,
                    showCounter: true,
                    footerHint: SZodiac.of(context)
                        .explainIn3to5StepsWhatTheCustomersWillGetZodiac,
                    errorType: errorTextsMap[entry]
                            ?[ZodiacConstants.serviceDescriptionIndex] ??
                        ValidationErrorType.empty,
                    approvalStatus: approvalStatusMap?[entry]
                        ?[ZodiacConstants.serviceDescriptionIndex],
                  );
                }),
          ],
        );
      }).toList(),
    );
  }
}
