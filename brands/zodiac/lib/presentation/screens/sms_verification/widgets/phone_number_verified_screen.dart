import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_elevated_button.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/common_widgets/appbar/simple_app_bar.dart';
import 'package:zodiac/zodiac_main_cubit.dart';

class PhoneNumberVerifiedScreen extends StatelessWidget {
  const PhoneNumberVerifiedScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: SimpleAppBar(
        title: SZodiac.of(context).phoneNumberZodiac,
        backOnClick: () => popAndUpdateAccountSettings(context),
      ),
      backgroundColor: theme.canvasColor,
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(
            AppConstants.horizontalScreenPadding,
          ),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      Assets.zodiac.vectors.phoneNumberVerified.path,
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
                  ],
                ),
              ),
              AppElevatedButton(
                title: SZodiac.of(context).gotItZodiac,
                onPressed: () => popAndUpdateAccountSettings(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void popAndUpdateAccountSettings(BuildContext context) {
    context.popUntilRoot();
    context.read<ZodiacMainCubit>().updateAccauntSettings();
  }
}