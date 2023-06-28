import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/screens/sms_verification/sms_verification_cubit.dart';

class VerificationCodeWidget extends StatelessWidget {
  const VerificationCodeWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Builder(builder: (context) {
      SMSVerificationCubitCubit smsVerificationCubitCubit =
          context.read<SMSVerificationCubitCubit>();
      final isError = context
          .select((SMSVerificationCubitCubit cubit) => cubit.state.isError);
      return Column(
        children: [
          SizedBox(
            width: verificationCodeInputFieldCount *
                    AppConstants.textFieldsHeight +
                (verificationCodeInputFieldCount - 1) * 8.0,
            height: 48,
            child: PinCodeTextField(
              appContext: context,
              autoFocus: true,
              autoDisposeControllers: false,
              focusNode: smsVerificationCubitCubit.codeTextFieldFocus,
              textStyle: theme.textTheme.bodyMedium?.copyWith(
                color: theme.hoverColor,
              ),
              pastedTextStyle: theme.textTheme.bodyMedium?.copyWith(
                color: theme.hoverColor,
              ),
              length: verificationCodeInputFieldCount,
              blinkWhenObscuring: true,
              animationType: AnimationType.none,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(12.0),
                fieldWidth: AppConstants.textFieldsHeight,
                fieldHeight: AppConstants.textFieldsHeight,
                activeColor: isError ? theme.errorColor : theme.dividerColor,
                selectedColor: theme.primaryColor,
                inactiveColor: theme.dividerColor,
                selectedFillColor: theme.canvasColor,
                inactiveFillColor: theme.canvasColor,
                borderWidth: 1.0,
              ),
              cursorColor: Theme.of(context).colorScheme.secondary,
              animationDuration: const Duration(milliseconds: 300),
              enableActiveFill: false,
              controller:
                  smsVerificationCubitCubit.verificationCodeInputController,
              keyboardType: TextInputType.number,
              onChanged: (text) => smsVerificationCubitCubit
                  .updateVerifyButtonEnabled(text.length),
              beforeTextPaste: (text) {
                //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                //but you can show anything you want here, like your pop up saying wrong paste format or etc
                return false;
              },
            ),
          ),
          if (isError)
            Text(
              SZodiac.of(context).incorrectCodeZodiac,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 12.0,
                color: theme.errorColor,
              ),
            ),
        ],
      );
    });
  }
}
