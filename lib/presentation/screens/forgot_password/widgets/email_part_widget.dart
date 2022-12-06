import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/text_fields/app_text_field.dart';
import 'package:shared_advisor_interface/presentation/screens/forgot_password/forgot_password_cubit.dart';

class EmailPart extends StatelessWidget {
  const EmailPart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Builder(builder: (context) {
          final ForgotPasswordCubit cubit = context.read<ForgotPasswordCubit>();
          final String emailErrorText = context.select(
              (ForgotPasswordCubit cubit) => cubit.state.emailErrorText);
          context
              .select((ForgotPasswordCubit cubit) => cubit.state.emailHasFocus);
          return Padding(
            padding: EdgeInsets.only(
              bottom: emailErrorText.isEmpty ? 2.0 : 8.0,
            ),
            child: AppTextField(
              errorText: emailErrorText,
              label: S.of(context).email,
              focusNode: cubit.emailNode,
              textInputType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              controller: cubit.emailController,
            ),
          );
        }),
        Padding(
          padding: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 24.0),
          child: Text(
            S.of(context).toResetPasswordEnterEmailAddressAndWellSendYou,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).shadowColor,
                ),
          ),
        ),
      ],
    );
  }
}
