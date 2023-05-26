import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/data/cache/global_caching_manager.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.gr.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_elevated_button.dart';
import 'package:shared_advisor_interface/services/connectivity_service.dart';
import 'package:zodiac/data/models/settings/phone.dart';
import 'package:zodiac/data/models/settings/phone_country_code.dart';
import 'package:zodiac/domain/repositories/zodiac_user_repository.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/infrastructure/di/inject_config.dart';
import 'package:zodiac/presentation/common_widgets/appbar/phone_number_app_bar.dart';
import 'package:zodiac/presentation/common_widgets/text_fields/app_text_field.dart';
import 'package:zodiac/presentation/screens/phone_number/phone_number_cubit.dart';
import 'package:zodiac/presentation/screens/phone_number/widgets/country_code_widget.dart';

class PhoneNumberScreen extends StatelessWidget {
  final Phone? phone;
  const PhoneNumberScreen({
    super.key,
    required this.phone,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocProvider(
      create: (_) => PhoneNumberCubit(
        phone ?? const Phone(),
        zodiacGetIt.get<ZodiacUserRepository>(),
        zodiacGetIt.get<ConnectivityService>(),
        zodiacGetIt.get<GlobalCachingManager>(),
      ),
      child: Builder(builder: (context) {
        PhoneNumberCubit phoneNumberCubit = context.read<PhoneNumberCubit>();
        return Scaffold(
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
                          SZodiac.of(context)
                              .confirmYourCountryCodeAndEnterYourPhoneNumberZodiac,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineMedium?.copyWith(
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
                                context.select((PhoneNumberCubit cubit) =>
                                    cubit.state.phone.code);
                                return CountryCodeWidget(
                                  code: phoneNumberCubit.state.phone
                                      .toCodeString(),
                                  country:
                                      phoneNumberCubit.state.phone.country ??
                                          '',
                                  onTap: () async {
                                    phoneNumberCubit.setTextInputFocus(false);
                                    final PhoneCountryCode?
                                        selectedPhoneCountryCode =
                                        await context.push<PhoneCountryCode>(
                                      route: const ZodiacPhoneCodeSearch(),
                                    );
                                    if (selectedPhoneCountryCode != null) {
                                      phoneNumberCubit.setPhoneCountryCode(
                                          selectedPhoneCountryCode);
                                    }
                                  },
                                );
                              }),
                            ),
                            const SizedBox(
                              width: 8.0,
                            ),
                            Expanded(
                              child: Builder(builder: (context) {
                                context.select((PhoneNumberCubit cubit) =>
                                    cubit.state.isPhoneNumberInputFocused);
                                final maxLength = context.select(
                                    (PhoneNumberCubit cubit) =>
                                        cubit.state.phoneNumberMaxLength);
                                return AppTextField(
                                  maxLength: maxLength ?? pnoneNumberMaxLength,
                                  textInputType: TextInputType.number,
                                  focusNode:
                                      phoneNumberCubit.phoneNumberInputFocus,
                                  controller: phoneNumberCubit
                                      .phoneNumberInputController,
                                  label: SZodiac.of(context).phoneZodiac,
                                );
                              }),
                            )
                          ],
                        ),
                        const Spacer(),
                        Builder(builder: (context) {
                          final verificationCodeAttempts = context.select(
                              (PhoneNumberCubit cubit) =>
                                  cubit.state.verificationCodeAttempts);
                          final attempts =
                              '$verificationCodeAttempts/$verificationCodeAttemptsPer24HoursMax';
                          final List<String> youHaveVerificationAttemptsPerDay =
                              SZodiac.of(context)
                                  .youHaveVerificationAttemptsPerDayZodiac(
                                      attempts)
                                  .split(attempts);
                          return verificationCodeAttempts != 0
                              ? Text.rich(
                                  TextSpan(
                                    text:
                                        youHaveVerificationAttemptsPerDay.first,
                                    style: theme.textTheme.bodyMedium?.copyWith(
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
                                )
                              : const SizedBox.shrink();
                        }),
                        const SizedBox(
                          height: 16.0,
                        ),
                        Builder(builder: (context) {
                          final isSendCodeButtonEnabled = context.select(
                              (PhoneNumberCubit cubit) =>
                                  cubit.state.isSendCodeButtonEnabled);
                          return AppElevatedButton(
                            title: SZodiac.of(context).sendCodeZodiac,
                            onPressed: isSendCodeButtonEnabled
                                ? () async {
                                    if (await phoneNumberCubit.sendCode()) {
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
              );
            }),
          ),
        );
      }),
    );
  }
}
