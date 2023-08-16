import 'package:flutter/material.dart';
import 'package:zodiac/data/models/enums/approval_status.dart';
import 'package:zodiac/data/models/enums/validation_error_type.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/common_widgets/text_fields/app_text_field.dart';
import 'package:zodiac/zodiac_constants.dart';

class TitleDescriptionPartWidget extends StatelessWidget {
  final int selectedLanguageIndex;
  final Map<String, List<TextEditingController>> textControllersMap;
  final Map<String, List<ValueNotifier>> hasFocusNotifiersMap;
  final Map<String, List<ValidationErrorType>> errorTextsMap;
  final Map<String, List<FocusNode>> focusNodesMap;
  final Map<String, List<ApprovalStatus?>>? approvalStatusMap;

  const TitleDescriptionPartWidget({
    Key? key,
    required this.selectedLanguageIndex,
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
      children: textControllersMap.entries.map((entry) {
        return Column(
          children: [
            ValueListenableBuilder(
                valueListenable: hasFocusNotifiersMap[entry.key]![
                    ZodiacConstants.serviceTitleIndex],
                builder: (context, value, child) {
                  return AppTextField(
                    controller: entry.value[ZodiacConstants.serviceTitleIndex],
                    focusNode: focusNodesMap[entry.key]![
                        ZodiacConstants.serviceTitleIndex],
                    label: SZodiac.of(context).titleZodiac,
                    hintText: SZodiac.of(context).egAstrologyReadingZodiac,
                    maxLength: 40,
                    errorType: errorTextsMap[entry.key]
                            ?[ZodiacConstants.serviceTitleIndex] ??
                        ValidationErrorType.empty,
                    approvalStatus: approvalStatusMap?[entry.key]
                        ?[ZodiacConstants.serviceTitleIndex],
                  );
                }),
            const SizedBox(
              height: 24.0,
            ),
            ValueListenableBuilder(
                valueListenable: hasFocusNotifiersMap[entry.key]![
                    ZodiacConstants.serviceDescriptionIndex],
                builder: (context, value, child) {
                  return AppTextField(
                    controller:
                        entry.value[ZodiacConstants.serviceDescriptionIndex],
                    focusNode: focusNodesMap[entry.key]![
                        ZodiacConstants.serviceDescriptionIndex],
                    isBig: true,
                    label: SZodiac.of(context).descriptionZodiac,
                    hintText: SZodiac.of(context).serviceDescriptionHintZodiac,
                    maxLength: 280,
                    showCounter: true,
                    footerHint: SZodiac.of(context)
                        .explainIn3to5StepsWhatTheCustomersWillGetZodiac,
                    errorType: errorTextsMap[entry.key]
                            ?[ZodiacConstants.serviceDescriptionIndex] ??
                        ValidationErrorType.empty,
                    approvalStatus: approvalStatusMap?[entry.key]
                        ?[ZodiacConstants.serviceDescriptionIndex],
                  );
                }),
          ],
        );
      }).toList(),
    );
  }
}
