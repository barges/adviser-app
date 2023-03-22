import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/screens/login/login_cubit.dart';

class ForgotPasswordButtonWidget extends StatelessWidget {
  const ForgotPasswordButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LoginCubit loginCubit = context.read<LoginCubit>();
    return GestureDetector(
      onTap: () => loginCubit.goToForgotPassword(context),
      child: Text(
        '${SZodiac.of(context).forgotPasswordZodiac}?',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }
}
