import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_elevated_button.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/common_widgets/appbar/phone_number_app_bar.dart';

class PhoneNumberVerifiedScreen extends StatelessWidget {
  const PhoneNumberVerifiedScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PhoneNumberAppBar(
        onTap: () => context.popUntilRoot(),
      ),
      backgroundColor: theme.canvasColor,
      body: SafeArea(
        top: false,
        child: LayoutBuilder(builder: (context, constraints) {
          return Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.horizontalScreenPadding),
            child: Column(
              children: [
                const Spacer(),
                SvgPicture.asset(
                  Assets.zodiac.phoneNumberVerified.path,
                  height: AppConstants.logoSize,
                  width: AppConstants.logoSize,
                ),
                const SizedBox(
                  height: 24.0,
                ),
                Text(
                  SZodiac.of(context).phoneNumberVerifiedZodiac,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontSize: 17.0,
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Text(
                  SZodiac.of(context).nowYouCanReceiveCallsZodiac,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 16.0,
                    color: theme.shadowColor,
                  ),
                ),
                const Spacer(),
                AppElevatedButton(
                  title: SZodiac.of(context).gotItZodiac,
                  onPressed: () => context.popUntilRoot(),
                ),
                const SizedBox(
                  height: 49.0,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
