import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/data/cache/cache_manager.dart';
import 'package:shared_advisor_interface/domain/repositories/auth_repository.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/app_text_field.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/appbar/login_appbar.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_elevated_button.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/messages/app_error_widget.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/messages/app_succes_widget.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/password_text_field.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/screens/login/login_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/login/widgets/choose_brand_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          LoginCubit(Get.find<AuthRepository>(), Get.find<CacheManager>()),
      child: Builder(
        builder: (BuildContext context) {
          final LoginCubit loginCubit = context.read<LoginCubit>();
          return Scaffold(
            appBar: const LoginAppBar(),
            body: SafeArea(
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                  loginCubit.clearErrorMessage();
                },
                child: Column(
                  children: [
                    Builder(
                      builder: (BuildContext context) {
                        final String errorMessage = context.select(
                            (MainCubit cubit) => cubit.state.errorMessage);
                        return errorMessage.isNotEmpty
                            ? AppErrorWidget(
                                errorMessage: errorMessage,
                                close: () {
                                  loginCubit.clearErrorMessage();
                                },
                              )
                            : const SizedBox.shrink();
                      },
                    ),
                    Builder(
                      builder: (BuildContext context) {
                        final bool showEmailButton = context.select(
                            (LoginCubit cubit) =>
                                cubit.state.showOpenEmailButton);
                        final String message = context.select(
                            (LoginCubit cubit) => cubit.state.successMessage);
                        return message.isNotEmpty
                            ? AppSuccessWidget(
                                message: message,
                                showEmailButton: showEmailButton,
                                close: () {
                                  loginCubit.clearSuccessMessage();
                                },
                              )
                            : const SizedBox.shrink();
                      },
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 16.0,
                            ),
                            const ChooseBrandWidget(),
                            const SizedBox(
                              height: 24.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal:
                                    AppConstants.horizontalScreenPadding,
                              ),
                              child: Column(
                                children: [
                                  Builder(builder: (BuildContext context) {
                                    final String emailErrorText =
                                        context.select((LoginCubit cubit) =>
                                            cubit.state.emailErrorText);
                                    return AppTextField(
                                      errorText: emailErrorText,
                                      label: S.of(context).email,
                                      textInputType: TextInputType.emailAddress,
                                      textInputAction: TextInputAction.next,
                                      nextFocusNode: loginCubit.passwordNode,
                                      controller: loginCubit.emailController,
                                    );
                                  }),
                                  const SizedBox(
                                    height: 24.0,
                                  ),
                                  Builder(builder: (BuildContext context) {
                                    final bool hiddenPassword = context.select(
                                        (LoginCubit cubit) =>
                                            cubit.state.hiddenPassword);
                                    final String passwordErrorText =
                                        context.select((LoginCubit cubit) =>
                                            cubit.state.passwordErrorText);
                                    return PasswordTextField(
                                      controller: loginCubit.passwordController,
                                      focusNode: loginCubit.passwordNode,
                                      label: S.of(context).password,
                                      errorText: passwordErrorText,
                                      textInputAction: TextInputAction.next,
                                      onSubmitted: (_) => loginCubit.login,
                                      hiddenPassword: hiddenPassword,
                                      clickToHide: loginCubit.showHidePassword,
                                    );
                                  }),
                                  const SizedBox(
                                    height: 24.0,
                                  ),
                                  AppElevatedButton(
                                    title: S.of(context).login,
                                    onPressed: loginCubit.login,
                                  ),
                                  const SizedBox(
                                    height: 22.0,
                                  ),
                                  GestureDetector(
                                    onTap: loginCubit.goToForgotPassword,
                                    child: Text(
                                      '${S.of(context).forgotPassword}?',
                                      style:
                                          Get.textTheme.titleMedium?.copyWith(
                                        color: Get.theme.primaryColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 24.0,
                              ),
                              child: Get.isDarkMode
                                  ? Assets.images.logos.loginLogoDark.image(
                                      height: AppConstants.logoSize,
                                      width: AppConstants.logoSize,
                                    )
                                  : Assets.images.logos.loginLogo.image(
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
              ),
            ),
          );
        },
      ),
    );
  }
}
