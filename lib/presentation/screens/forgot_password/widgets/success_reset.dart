import 'package:flutter/material.dart';

import '../../../../infrastructure/routing/app_router.dart';
import '../../../../app_constants.dart';
import '../../../../generated/assets/assets.gen.dart';
import '../../../../generated/l10n.dart';
import '../../../../global.dart';
import '../../../../infrastructure/routing/app_router.gr.dart';
import '../../../../infrastructure/routing/route_paths_fortunica.dart';
import '../../../../utils/utils.dart';
import '../../../common_widgets/buttons/app_elevated_button.dart';

class SuccessResetWidget extends StatelessWidget {
  const SuccessResetWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                    logger.d(context.previousRoutePath);
                    if (context.previousRoutePath ==
                            RoutePathsFortunica.loginScreen ||
                        context.previousRoutePath ==
                            RoutePathsFortunica.authScreen) {
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
