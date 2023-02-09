import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/data/models/enums/validation_error_type.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/text_fields/password_text_field.dart';
import 'package:shared_advisor_interface/presentation/screens/forgot_password/forgot_password_cubit.dart';

class ResetPasswordInputPart extends StatelessWidget {
  const ResetPasswordInputPart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ForgotPasswordCubit cubit = context.read<ForgotPasswordCubit>();
    return Column(
      children: [
        Builder(builder: (context) {
          final ValidationErrorType passwordErrorType = context.select(
              (ForgotPasswordCubit cubit) => cubit.state.passwordErrorType);
          final bool hiddenPassword = context.select(
              (ForgotPasswordCubit cubit) => cubit.state.hiddenPassword);
          context.select(
              (ForgotPasswordCubit cubit) => cubit.state.passwordHasFocus);
          return PasswordTextField(
            controller: cubit.passwordController,
            focusNode: cubit.passwordNode,
            label: S.of(context).newPassword,
            hintText: S.of(context).enterNewPassword,
            errorType: passwordErrorType,
            textInputAction: TextInputAction.next,
            onSubmitted: (_) {
              FocusScope.of(context).requestFocus(cubit.confirmPasswordNode);
            },
            hiddenPassword: hiddenPassword,
            clickToHide: cubit.showHidePassword,
          );
        }),
        Builder(builder: (context) {
          final ValidationErrorType confirmPasswordErrorType = context.select(
              (ForgotPasswordCubit cubit) =>
                  cubit.state.confirmPasswordErrorType);
          final bool hiddenConfirmPassword = context.select(
              (ForgotPasswordCubit cubit) => cubit.state.hiddenConfirmPassword);
          context.select((ForgotPasswordCubit cubit) =>
              cubit.state.confirmPasswordHasFocus);
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: PasswordTextField(
              controller: cubit.confirmPasswordController,
              focusNode: cubit.confirmPasswordNode,
              label: S.of(context).confirmNewPassword,
              hintText: S.of(context).repeatNewPassword,
              errorType: confirmPasswordErrorType,
              textInputAction: TextInputAction.send,
              hiddenPassword: hiddenConfirmPassword,
              clickToHide: cubit.showHideConfirmPassword,
            ),
          );
        }),
      ],
    );
  }
}
