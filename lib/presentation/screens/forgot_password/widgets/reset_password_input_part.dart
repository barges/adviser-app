import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
          final String passwordErrorText = context.select(
              (ForgotPasswordCubit cubit) => cubit.state.passwordErrorText);
          final bool hiddenPassword = context.select(
              (ForgotPasswordCubit cubit) => cubit.state.hiddenPassword);
          context.select(
              (ForgotPasswordCubit cubit) => cubit.state.passwordHasFocus);
          return PasswordTextField(
            controller: cubit.passwordController,
            focusNode: cubit.passwordNode,
            label: S.of(context).password,
            errorText: passwordErrorText,
            textInputAction: TextInputAction.next,
            onSubmitted: (_) {
              FocusScope.of(context).requestFocus(cubit.confirmPasswordNode);
            },
            hiddenPassword: hiddenPassword,
            clickToHide: cubit.showHidePassword,
          );
        }),
        Builder(builder: (context) {
          final String confirmPasswordErrorText = context.select(
              (ForgotPasswordCubit cubit) =>
                  cubit.state.confirmPasswordErrorText);
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
              errorText: confirmPasswordErrorText,
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
