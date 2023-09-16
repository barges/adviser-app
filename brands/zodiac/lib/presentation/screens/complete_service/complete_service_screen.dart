import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_elevated_button.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/common_widgets/appbar/simple_app_bar.dart';
import 'package:zodiac/presentation/screens/services_messages/canned_messages/widgets/message_text_field.dart';

class CompleteServiceScreen extends StatelessWidget {
  const CompleteServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
        appBar: SimpleAppBar(
          title: SZodiac.of(context).completeTheServiceZodiac,
        ),
        backgroundColor: theme.canvasColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.horizontalScreenPadding,
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 24.0,
                ),
                Text(
                  SZodiac.of(context)
                      .theServiceSsuccessfullyCompletedZodiac('Karma cleaning'),
                  style:
                      theme.textTheme.headlineMedium?.copyWith(fontSize: 17.0),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Text(
                  '${SZodiac.of(context).youCanProvideFeedbackToZodiac} Wade Warren',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 16.0,
                    color: theme.shadowColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 24.0,
                ),
                MessageTextField(
                  title: SZodiac.of(context).writeYourMessageZodiac,
                  note: SZodiac.of(context).needAtLeast20SymbolsZodiac,
                  controller: TextEditingController(),
                ),
                const SizedBox(
                  height: 32.0,
                ),
                AppElevatedButton(
                  title: SZodiac.of(context).sendZodiac,
                  onPressed: () => '',
                ),
                const SizedBox(
                  height: 25.0,
                ),
                GestureDetector(
                  onTap: () => 'context.popRoute()',
                  child: Text(
                    SZodiac.of(context).cancelZodiac,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w500,
                      color: theme.shadowColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
