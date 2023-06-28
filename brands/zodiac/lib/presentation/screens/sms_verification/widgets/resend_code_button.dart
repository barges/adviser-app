// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/ok_cancel_alert.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/screens/sms_verification/sms_verification_cubit.dart';

class ResendCodeButton extends StatelessWidget {
  const ResendCodeButton({super.key});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    SMSVerificationCubitCubit smsVerificationCubitCubit =
        context.read<SMSVerificationCubitCubit>();
    return Builder(builder: (context) {
      final bool isOnline = context.select(
          (MainCubit cubit) => cubit.state.internetConnectionIsAvailable);
      final isResendCodeButtonEnabled = context.select(
          (SMSVerificationCubitCubit cubit) =>
              cubit.state.isResendCodeButtonEnabled);
      // TODO Implement after attempts will be add on backend
      const String attempts = '0/3';
      return GestureDetector(
        onTap: isOnline && isResendCodeButtonEnabled
            ? () async {
                if (await smsVerificationCubitCubit.resendCode()) {
                  await showOkCancelAlert(
                    context: context,
                    title: SZodiac.of(context).successZodiac,
                    description: SZodiac.of(context).weveSentYouNewCodeZodiac,
                    okText: SZodiac.of(context).okZodiac,
                    allowBarrierClick: false,
                    isCancelEnabled: false,
                  );
                }
              }
            : null,
        child: Opacity(
          opacity: isOnline && isResendCodeButtonEnabled ? 1.0 : 0.4,
          child: Text(
            isResendCodeButtonEnabled
                ? SZodiac.of(context).resendCodeZodiac(attempts)
                : SZodiac.of(context)
                    .nextAttemptInZodiac(inactiveResendCodeDurationInSec),
            textAlign: TextAlign.center,
            style: theme.textTheme.labelMedium?.copyWith(
              fontSize: 17.0,
              color: theme.primaryColor,
            ),
          ),
        ),
      );
    });
  }
}
