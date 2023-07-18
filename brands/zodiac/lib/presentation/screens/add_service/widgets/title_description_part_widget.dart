import 'package:flutter/material.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/common_widgets/text_fields/app_text_field.dart';

class TitleDescriptionPartWidget extends StatelessWidget {
  const TitleDescriptionPartWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTextField(
          label: SZodiac.of(context).titleZodiac,
          hintText: SZodiac.of(context).egAstrologyReadingZodiac,
        ),
        const SizedBox(
          height: 24.0,
        ),
        AppTextField(
          isBig: true,
          label: SZodiac.of(context).descriptionZodiac,
          hintText: SZodiac.of(context).serviceDescriptionHintZodiac,
          maxLength: 280,
          showCounter: true,
        ),
      ],
    );
  }
}
