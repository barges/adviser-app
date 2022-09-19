import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/configuration.dart';
import 'package:shared_advisor_interface/domain/repositories/auth_repository.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/app_loading_indicator.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/appbar/wide_app_bar.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_elevated_button.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/email_field_widget.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/messages/app_error_widget.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/password_field_widget.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/screens/forgot_password/forgot_password_cubit.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ForgotPasswordCubit(Get.find<AuthRepository>()),
      child: Builder(
        builder: (context) {
          final ForgotPasswordCubit cubit = context.read<ForgotPasswordCubit>();
          return Stack(
            children: [
              Scaffold(
                appBar: WideAppBar(
                  title: S.of(context).forgotPassword,
                ),
                body: Stack(
                  children: [
                    SafeArea(
                      child: GestureDetector(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          cubit.clearErrorMessage();
                        },
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppConstants.horizontalScreenPadding),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 24.0),
                                  child: _BrandLogo(
                                    brand: cubit.selectedBrand,
                                  ),
                                ),
                                Builder(builder: (context) {
                                  final String email = context.select(
                                      (ForgotPasswordCubit cubit) =>
                                          cubit.state.email);
                                  return EmailFieldWidget(
                                    showErrorText: !cubit.emailIsValid() &&
                                        email.isNotEmpty,
                                    nextFocusNode: cubit.passwordNode,
                                    controller: cubit.emailController,
                                  );
                                }),
                                const SizedBox(
                                  height: 16.0,
                                ),
                                Builder(builder: (context) {
                                  final String password = context.select(
                                      (ForgotPasswordCubit cubit) =>
                                          cubit.state.password);
                                  final bool hiddenPassword = context.select(
                                      (ForgotPasswordCubit cubit) =>
                                          cubit.state.hiddenPassword);
                                  return PasswordFieldWidget(
                                    controller: cubit.passwordController,
                                    focusNode: cubit.passwordNode,
                                    label: S.of(context).password,
                                    errorText: S
                                        .of(context)
                                        .pleaseEnterAtLeast8Characters,
                                    textInputAction: TextInputAction.next,
                                    showErrorText: !cubit.passwordIsValid() &&
                                        password.isNotEmpty,
                                    onSubmitted: (_) {
                                      FocusScope.of(context).requestFocus(
                                          cubit.confirmPasswordNode);
                                    },
                                    hiddenPassword: hiddenPassword,
                                    clickToHide: cubit.showHidePassword,
                                  );
                                }),
                                Builder(builder: (context) {
                                  final String confirmPassword = context.select(
                                      (ForgotPasswordCubit cubit) =>
                                          cubit.state.confirmPassword);
                                  final bool hiddenConfirmPassword = context
                                      .select((ForgotPasswordCubit cubit) =>
                                          cubit.state.hiddenConfirmPassword);
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16.0),
                                    child: PasswordFieldWidget(
                                      controller:
                                          cubit.confirmPasswordController,
                                      focusNode: cubit.confirmPasswordNode,
                                      label: S.of(context).confirmNewPassword,
                                      errorText:
                                          S.of(context).thePasswordsMustMatch,
                                      showErrorText:
                                          !cubit.confirmPasswordIsValid() &&
                                              confirmPassword.isNotEmpty,
                                      textInputAction: TextInputAction.send,
                                      onSubmitted: (_) => cubit.resetPassword(),
                                      hiddenPassword: hiddenConfirmPassword,
                                      clickToHide:
                                          cubit.showHideConfirmPassword,
                                    ),
                                  );
                                }),
                                AppElevatedButton(
                                  text: S.of(context).changePassword,
                                  onPressed: () {
                                    if (!cubit.state.isLoading) {
                                      cubit.resetPassword();
                                    }
                                  },
                                )
                              ]),
                        ),
                      ),
                    ),
                    Builder(
                      builder: (BuildContext context) {
                        final String errorMessage = context.select(
                            (ForgotPasswordCubit cubit) =>
                                cubit.state.errorMessage);
                        return errorMessage.isNotEmpty
                            ? AppErrorWidget(
                                errorMessage: errorMessage,
                                close: () {
                                  cubit.clearErrorMessage();
                                },
                              )
                            : const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ),
              Builder(
                builder: (context) {
                  final bool isLoading = context.select(
                      (ForgotPasswordCubit cubit) => cubit.state.isLoading);
                  return AppLoadingIndicator(
                    showIndicator: isLoading,
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class _BrandLogo extends StatelessWidget {
  final Brand? brand;

  const _BrandLogo({Key? key, required this.brand}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 96.0,
      width: 96.0,
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Get.theme.canvasColor,
      ),
      child: Center(
        child: SvgPicture.asset(
          brand?.icon ?? '',
          height: 72.0,
        ),
      ),
    );
  }
}
