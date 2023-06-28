import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/data/models/app_error/app_error.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.gr.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_elevated_button.dart';
import 'package:zodiac/data/models/settings/phone.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/infrastructure/di/inject_config.dart';
import 'package:zodiac/presentation/common_widgets/appbar/simple_app_bar.dart';
import 'package:zodiac/presentation/common_widgets/messages/app_error_widget.dart';
import 'package:zodiac/presentation/screens/phone_number/phone_number_cubit.dart';
import 'package:zodiac/presentation/screens/phone_number/widgets/country_code_widget.dart';
import 'package:zodiac/presentation/screens/phone_number/widgets/phone_number_text_field.dart';
import 'package:zodiac/zodiac_main_cubit.dart';

import 'widgets/phone_code_search_widget.dart';

class PhoneNumberScreen extends StatelessWidget {
  final String? siteKey;
  final Phone phone;
  const PhoneNumberScreen({
    super.key,
    required this.siteKey,
    required this.phone,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocProvider(
      create: (_) => zodiacGetIt.get<PhoneNumberCubit>(
        param1: siteKey,
        param2: phone,
      ),
      child: Builder(
        builder: (context) {
          PhoneNumberCubit phoneNumberCubit = context.read<PhoneNumberCubit>();
          return Stack(
            children: [
              Scaffold(
                resizeToAvoidBottomInset: false,
                appBar: SimpleAppBar(
                  title: SZodiac.of(context).phoneNumberZodiac,
                ),
                backgroundColor: theme.canvasColor,
                body: SafeArea(
                    top: false,
                    child: Column(
                      children: [
                        Builder(builder: (context) {
                          final AppError appError = context.select(
                              (ZodiacMainCubit cubit) => cubit.state.appError);
                          final bool internetConnectionIsAvailable =
                              context.select((MainCubit cubit) =>
                                  cubit.state.internetConnectionIsAvailable);
                          return AppErrorWidget(
                            errorMessage: !internetConnectionIsAvailable
                                ? SZodiac.of(context).noInternetConnectionZodiac
                                : appError.getMessage(context),
                            close: internetConnectionIsAvailable
                                ? phoneNumberCubit.clearErrorMessage
                                : null,
                          );
                        }),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal:
                                    AppConstants.horizontalScreenPadding),
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 24.0,
                                ),
                                Text(
                                  SZodiac.of(context)
                                      .confirmYourCountryCodeAndEnterYourPhoneNumberZodiac,
                                  textAlign: TextAlign.center,
                                  style:
                                      theme.textTheme.headlineMedium?.copyWith(
                                    fontSize: 17.0,
                                  ),
                                ),
                                const SizedBox(
                                  height: 8.0,
                                ),
                                Text(
                                  SZodiac.of(context)
                                      .wellTextYouCodeToVerifyYourPhoneNumberZodiac,
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontSize: 16.0,
                                    color: theme.shadowColor,
                                  ),
                                ),
                                const SizedBox(
                                  height: 24.0,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 75.0,
                                      child: Builder(builder: (context) {
                                        context.select(
                                            (PhoneNumberCubit cubit) =>
                                                cubit.state.phone.code);
                                        return CountryCodeWidget(
                                          code: phoneNumberCubit.state.phone
                                              .toCodeString(),
                                          country: phoneNumberCubit
                                                  .state.phone.country ??
                                              '',
                                          onTap: () async {
                                            phoneNumberCubit
                                                .setTextInputFocus(false);
                                            phoneNumberCubit
                                                .updatePhoneCodeSearchVisibility(
                                                    true);
                                          },
                                        );
                                      }),
                                    ),
                                    const SizedBox(
                                      width: 8.0,
                                    ),
                                    Expanded(
                                      child: PhoneNumberTextField(
                                          text: phone.number != null
                                              ? phone.number.toString()
                                              : ''),
                                    )
                                  ],
                                ),
                                const Spacer(),
                                Builder(builder: (context) {
                                  // TODO Implement after attempts will be add on backend
                                  final verificationCodeAttempts =
                                      context.select((PhoneNumberCubit cubit) =>
                                          cubit.state.verificationCodeAttempts);
                                  final attempts =
                                      '$verificationCodeAttempts/$verificationCodeAttemptsPer24HoursMax';
                                  final List<String>
                                      youHaveVerificationAttemptsPerDay =
                                      SZodiac.of(context)
                                          .youHaveVerificationAttemptsPerDayZodiac(
                                              attempts)
                                          .split(attempts);
                                  return Text.rich(
                                    TextSpan(
                                      text: youHaveVerificationAttemptsPerDay
                                          .first,
                                      style:
                                          theme.textTheme.bodyMedium?.copyWith(
                                        fontSize: 16.0,
                                        color: theme.shadowColor,
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: attempts,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        TextSpan(
                                            text:
                                                youHaveVerificationAttemptsPerDay
                                                    .last),
                                      ],
                                    ),
                                  );
                                }),
                                const SizedBox(
                                  height: 16.0,
                                ),
                                Builder(builder: (context) {
                                  final bool isOnline = context.select(
                                      (MainCubit cubit) => cubit
                                          .state.internetConnectionIsAvailable);
                                  final isSendCodeButtonEnabled =
                                      context.select((PhoneNumberCubit cubit) =>
                                          cubit.state.isSendCodeButtonEnabled);
                                  return AppElevatedButton(
                                    title: SZodiac.of(context).sendCodeZodiac,
                                    onPressed: isOnline &&
                                            isSendCodeButtonEnabled
                                        ? () async {
                                            if (await phoneNumberCubit
                                                .sendCode()) {
                                              // ignore: use_build_context_synchronously
                                              context.push(
                                                route: ZodiacSMSVerification(
                                                    phoneNumber:
                                                        phoneNumberCubit.phone),
                                              );
                                            }
                                          }
                                        : null,
                                  );
                                }),
                                const SizedBox(
                                  height: 16.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
              Builder(builder: (context) {
                final bool isPhoneCodeSearchVisible = context.select(
                    (PhoneNumberCubit cubit) =>
                        cubit.state.isPhoneCodeSearchVisible);
                return isPhoneCodeSearchVisible
                    ? PhoneCodeSearchWidget()
                    : const SizedBox.shrink();
              }),
            ],
          );
        },
      ),
    );
  }
}
