import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/data/cache/global_caching_manager.dart';
import 'package:shared_advisor_interface/data/models/app_error/app_error.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.gr.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_elevated_button.dart';
import 'package:shared_advisor_interface/services/connectivity_service.dart';
import 'package:zodiac/data/models/settings/phone.dart';
import 'package:zodiac/domain/repositories/zodiac_user_repository.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/infrastructure/di/inject_config.dart';
import 'package:zodiac/presentation/common_widgets/appbar/simple_app_bar.dart';
import 'package:zodiac/presentation/common_widgets/messages/app_error_widget.dart';
import 'package:zodiac/presentation/screens/sms_verification/sms_verification_cubit.dart';
import 'package:zodiac/presentation/screens/sms_verification/widgets/resend_code_button.dart';
import 'package:zodiac/presentation/screens/sms_verification/widgets/verification_code_widget.dart';
import 'package:zodiac/zodiac_main_cubit.dart';

const verificationCodeInputFieldCount = 4;

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
      create: (context) => SMSVerificationCubitCubit(
        zodiacGetIt.get<MainCubit>(),
        zodiacGetIt.get<ZodiacMainCubit>(),
        zodiacGetIt.get<ZodiacUserRepository>(),
        zodiacGetIt.get<ConnectivityService>(),
        zodiacGetIt.get<GlobalCachingManager>(),
      ),
      child: Builder(builder: (context) {
        SMSVerificationCubitCubit smsVerificationCubitCubit =
            context.read<SMSVerificationCubitCubit>();
        final AppError appError =
            context.select((ZodiacMainCubit cubit) => cubit.state.appError);
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: SimpleAppBar(
            title: SZodiac.of(context).phoneNumberZodiac,
          ),
          backgroundColor: theme.canvasColor,
          body: SafeArea(
            top: false,
            child: LayoutBuilder(builder: (context, constraints) {
              return SingleChildScrollView(
                child: SizedBox(
                  height: constraints.maxHeight < 350.0
                      ? 350.0
                      : constraints.maxHeight,
                  child: Column(
                    children: [
                      AppErrorWidget(
                        errorMessage: appError.getMessage(context),
                        close: smsVerificationCubitCubit.clearErrorMessage,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppConstants.horizontalScreenPadding),
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
                              // TODO Implement after attempts will be add on backend
                              Builder(builder: (context) {
                                const String attempts = '0';
                                final List<String>
                                    youHaveAttemptsToEnterRightCode =
                                    SZodiac.of(context)
                                        .youHaveAttemptsToEnterRightCodeZodiac(
                                            attempts)
                                        .split(attempts);
                                return Text.rich(
                                  textAlign: TextAlign.center,
                                  TextSpan(
                                    text: youHaveAttemptsToEnterRightCode.first,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontSize: 16.0,
                                      color: theme.shadowColor,
                                    ),
                                    children: <TextSpan>[
                                      const TextSpan(
                                          text: attempts,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      TextSpan(
                                          text: youHaveAttemptsToEnterRightCode
                                              .last),
                                    ],
                                  ),
                                );
                              }),
                              const SizedBox(
                                height: 24.0,
                              ),
                              const VerificationCodeWidget(),
                              const Spacer(),
                              Builder(builder: (context) {
                                final isVerifyButtonEnabled = context.select(
                                    (SMSVerificationCubitCubit cubit) =>
                                        cubit.state.isVerifyButtonEnabled);
                                return AppElevatedButton(
                                  title: SZodiac.of(context).verifyZodiac,
                                  onPressed: isVerifyButtonEnabled
                                      ? () async {
                                          if (await smsVerificationCubitCubit
                                              .verifyPhoneNumber()) {
                                            // ignore: use_build_context_synchronously
                                            context.push(
                                              route:
                                                  const ZodiacPhoneNumberVerified(),
                                            );
                                          }
                                        }
                                      : null,
                                );
                              }),
                              const SizedBox(
                                height: 22.0,
                              ),
                              const ResendCodeButton(),
                              const SizedBox(
                                height: 26.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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
