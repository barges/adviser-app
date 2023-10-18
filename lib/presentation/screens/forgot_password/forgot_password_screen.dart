import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../app_constants.dart';
import '../../../data/models/app_error/app_error.dart';
import '../../../domain/repositories/fortunica_auth_repository.dart';
import '../../../generated/assets/assets.gen.dart';
import '../../../generated/l10n.dart';
import '../../../infrastructure/di/inject_config.dart';
import '../../../main_cubit.dart';
import '../../../services/dynamic_link_service.dart';
import '../../../utils/utils.dart';
import '../../common_widgets/appbars/simple_app_bar.dart';
import '../../common_widgets/buttons/app_elevated_button.dart';
import '../../common_widgets/messages/app_error_widget.dart';
import '../../common_widgets/no_connection_widget.dart';
import '../login/login_cubit.dart';
import 'forgot_password_cubit.dart';
import 'widgets/email_part_widget.dart';
import 'widgets/reset_password_input_part.dart';
import 'widgets/success_reset.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final String? resetToken;

  const ForgotPasswordScreen({
    Key? key,
    this.resetToken,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ForgotPasswordCubit(
        authRepository: fortunicaGetIt.get<FortunicaAuthRepository>(),
        dynamicLinkService: fortunicaGetIt.get<DynamicLinkService>(),
        loginCubit: fortunicaGetIt.get<LoginCubit>(),
        resetToken: resetToken,
        mainCubit: fortunicaGetIt.get<MainCubit>(),
      ),
      child: Builder(builder: (context) {
        final ForgotPasswordCubit cubit = context.read<ForgotPasswordCubit>();
        final bool isOnline = context.select(
            (MainCubit cubit) => cubit.state.internetConnectionIsAvailable);
        return Scaffold(
          appBar: SimpleAppBar(
            title: SFortunica.of(context).forgotPasswordFortunica,
          ),
          body: SafeArea(
            child: isOnline
                ? Builder(builder: (context) {
                    final bool isResetSuccess = context.select(
                        (ForgotPasswordCubit cubit) =>
                            cubit.state.isResetSuccess);
                    return isResetSuccess
                        ? const SuccessResetWidget()
                        : GestureDetector(
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              cubit.clearErrorMessage();
                            },
                            child: Column(
                              children: [
                                Builder(
                                  builder: (BuildContext context) {
                                    final AppError appError = context.select(
                                        (MainCubit cubit) =>
                                            cubit.state.appError);
                                    return AppErrorWidget(
                                      errorMessage:
                                          appError.getMessage(context),
                                      close: () {
                                        cubit.clearErrorMessage();
                                      },
                                    );
                                  },
                                ),
                                Expanded(
                                  child: SingleChildScrollView(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: AppConstants
                                            .horizontalScreenPadding),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 24.0),
                                          child: _BrandLogo(),
                                        ),
                                        Builder(builder: (context) {
                                          final String? resetToken =
                                              context.select(
                                                  (ForgotPasswordCubit cubit) =>
                                                      cubit.state.resetToken);
                                          return Column(
                                            children: [
                                              resetToken == null
                                                  ? const EmailPart()
                                                  : const ResetPasswordInputPart(),
                                              Builder(builder: (context) {
                                                final bool isActive =
                                                    context.select(
                                                  (ForgotPasswordCubit cubit) =>
                                                      cubit
                                                          .state.isButtonActive,
                                                );
                                                return AppElevatedButton(
                                                  title: resetToken == null
                                                      ? SFortunica.of(context)
                                                          .resetPasswordFortunica
                                                      : SFortunica.of(context)
                                                          .changePasswordFortunica,
                                                  onPressed: isActive
                                                      ? () =>
                                                          cubit.resetPassword(
                                                            context,
                                                            resetToken,
                                                          )
                                                      : null,
                                                );
                                              }),
                                            ],
                                          );
                                        }),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 24.0,
                                          ),
                                          child: Utils.isDarkMode(context)
                                              ? Assets.images.logos
                                                  .forgotPasswordLogoDark
                                                  .image(
                                                  height: AppConstants.logoSize,
                                                  width: AppConstants.logoSize,
                                                )
                                              : Assets.images.logos
                                                  .forgotPasswordLogo
                                                  .image(
                                                  height: AppConstants.logoSize,
                                                  width: AppConstants.logoSize,
                                                ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                  })
                : const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      NoConnectionWidget(),
                    ],
                  ),
          ),
        );
      }),
    );
  }
}

class _BrandLogo extends StatelessWidget {
  const _BrandLogo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        if (kDebugMode) {
          context.read<ForgotPasswordCubit>().emailController.text =
              'niskov.test@gmail.com';
        }
      },
      child: Container(
        height: 96.0,
        width: 96.0,
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            AppConstants.buttonRadius,
          ),
          color: Theme.of(context).canvasColor,
        ),
        child: Center(
          child: SvgPicture.asset(
            // TODO ?
            //FortunicaBrand().iconPath,
            Assets.vectors.fortunica.path,
            height: 72.0,
          ),
        ),
      ),
    );
  }
}
