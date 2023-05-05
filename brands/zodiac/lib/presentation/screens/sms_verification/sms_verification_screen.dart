import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.gr.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_elevated_button.dart';
import 'package:zodiac/data/models/settings/phone.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/common_widgets/appbar/phone_number_app_bar.dart';
import 'package:zodiac/presentation/screens/sms_verification/sms_verification_cubit.dart';
import 'package:zodiac/presentation/screens/sms_verification/widgets/verification_code_widget.dart';

class SMSVerificationScreen extends StatelessWidget {
  final Phone? phoneNumber;
  const SMSVerificationScreen({
    super.key,
    this.phoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocProvider(
      create: (context) => SMSVerificationCubitCubit(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: const PhoneNumberAppBar(),
        backgroundColor: theme.canvasColor,
        body: SafeArea(
          top: false,
          child: LayoutBuilder(builder: (context, constraints) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.horizontalScreenPadding),
                child: SizedBox(
                  height: constraints.maxHeight < 350.0
                      ? 350.0
                      : constraints.maxHeight,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 24.0,
                      ),
                      Text(
                        SZodiac.of(context).SMSverificationZodiac,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontSize: 17.0,
                        ),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Text(
                        phoneNumber != null
                            ? SZodiac.of(context)
                                .pleaseTypeTheVerificationCodeZodiac(
                                    phoneNumber!.toString())
                            : '',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 16.0,
                          color: theme.shadowColor,
                        ),
                      ),
                      Builder(builder: (context) {
                        const String attempts = '5';
                        final List<String> youHaveAttemptsToEnterRightCode =
                            SZodiac.of(context)
                                .youHaveAttemptsToEnterRightCodeZodiac(attempts)
                                .split(attempts);
                        return Text.rich(
                          TextSpan(
                            text: youHaveAttemptsToEnterRightCode.first,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontSize: 16.0,
                              color: theme.shadowColor,
                            ),
                            children: <TextSpan>[
                              const TextSpan(
                                  text: attempts,
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text: youHaveAttemptsToEnterRightCode.last),
                            ],
                          ),
                        );
                      }),
                      const SizedBox(
                        height: 24.0,
                      ),
                      Builder(builder: (context) {
                        final isError = context.select(
                            (SMSVerificationCubitCubit cubit) =>
                                cubit.state.isError);
                        return VerificationCodeWidget(isError: isError);
                      }),
                      const Spacer(),
                      AppElevatedButton(
                        title: SZodiac.of(context).verifyZodiac,
                        onPressed: true
                            ? () => context.push(
                                  route: const ZodiacPhoneNumberVerified(),
                                )
                            : null,
                      ),
                      const SizedBox(
                        height: 22.0,
                      ),
                      Builder(builder: (context) {
                        const String attempts = '3/3';
                        return Text(
                          SZodiac.of(context).resendCodeZodiac(attempts),
                          textAlign: TextAlign.center,
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontSize: 17.0,
                            color: theme.primaryColor,
                          ),
                        );
                      }),
                      const SizedBox(
                        height: 26.0,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
