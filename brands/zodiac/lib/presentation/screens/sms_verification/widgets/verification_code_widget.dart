import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:zodiac/presentation/screens/sms_verification/sms_verification_cubit.dart';

class VerificationCodeWidget extends StatelessWidget {
  final bool isError;
  const VerificationCodeWidget({
    super.key,
    this.isError = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Builder(builder: (context) {
      SMSVerificationCubitCubit smsVerificationCubitCubit =
          context.read<SMSVerificationCubitCubit>();
      return Column(
        children: [
          SizedBox(
            width: 216.0,
            height: 48,
            child: PinCodeTextField(
              appContext: context,
              autoFocus: true,
              autoUnfocus: false,
              focusNode: smsVerificationCubitCubit.codeTextFieldFocus,
              textStyle: theme.textTheme.bodyMedium?.copyWith(
                color: theme.hoverColor,
              ),
              pastedTextStyle: theme.textTheme.bodyMedium?.copyWith(
                color: theme.hoverColor,
              ),
              length: 4,
              blinkWhenObscuring: true,
              animationType: AnimationType.none,
              /*validator: (v) {
                  if (v!.length < 3) {
                    return "I'm from validator";
                  } else {
                    return null;
                  }
                },*/
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
              cursorColor: Theme.of(context).accentColor,
              animationDuration: const Duration(milliseconds: 300),
              enableActiveFill: false,
              //errorAnimationController: errorController,
              //controller: textEditingController,
              keyboardType: TextInputType.number,
              onCompleted: (v) {
                //print("Completed");
              },
              /*onTap: () {
                   print("Pressed");
                 },*/
              onChanged: (value) {
                //print(value);
              },
              beforeTextPaste: (text) {
                //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                //but you can show anything you want here, like your pop up saying wrong paste format or etc
                return false;
              },
            ),
          ),
          if (isError)
            Text(
              'Incorrect code',
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
