import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.gr.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_elevated_button.dart';
import 'package:shared_advisor_interface/utils/utils.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortunica/generated/l10n.dart';
import 'package:fortunica/infrastructure/routing/route_paths.dart';
import 'package:fortunica/presentation/screens/forgot_password/forgot_password_cubit.dart';

class SuccessResetWidget extends StatelessWidget {
  const SuccessResetWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ForgotPasswordCubit forgotPasswordCubit =
        context.read<ForgotPasswordCubit>();
    return CustomScrollView(
      physics: const ClampingScrollPhysics(),
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.horizontalScreenPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Utils.isDarkMode(context)
                    ? Assets.images.logos.successResetPasswordLogoDark.image(
                        height: AppConstants.logoSize,
                        width: AppConstants.logoSize,
                      )
                    : Assets.images.logos.successResetPasswordLogo.image(
                        height: AppConstants.logoSize,
                        width: AppConstants.logoSize,
                      ),
                const SizedBox(
                  height: 24.0,
                ),
                Text(
                  SFortunica.of(context).useYourNewPasswordToLoginFortunica,
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 24.0,
                ),
                AppElevatedButton(
                  title: SFortunica.of(context).loginFortunica,
                  onPressed: () {
                    if (context.previousRoutePath == RoutePaths.loginScreen) {
                      context.pop();
                    } else {
                      context.replace(route: const FortunicaLogin());
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
