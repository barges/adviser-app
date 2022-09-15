import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/data/cache/cache_manager.dart';
import 'package:shared_advisor_interface/domain/repositories/auth_repository.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/app_loading_indicator.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/appbar/login_appbar.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_elevated_button.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/email_field_widget.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/messages/app_error_widget.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/messages/app_succes_widget.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/password_field_widget.dart';
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
          final LoginCubit cubit = context.read<LoginCubit>();
          return Stack(
            children: [
              Scaffold(
                appBar: const LoginAppBar(),
                body: Stack(
                  children: [
                    SafeArea(
                      child: GestureDetector(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          cubit.clearErrorMessage();
                        },
                        child: SingleChildScrollView(
                          child: Column(children: [
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
                                    final String email = context.select(
                                        (LoginCubit cubit) =>
                                            cubit.state.email);
                                    return EmailFieldWidget(
                                      showErrorText: !cubit.emailIsValid() &&
                                          email.isNotEmpty,
                                      nextFocusNode: cubit.passwordNode,
                                      controller: cubit.emailController,
                                    );
                                  }),
                                  const SizedBox(
                                    height: 24.0,
                                  ),
                                  Builder(builder: (BuildContext context) {
                                    final bool hiddenPassword = context.select(
                                        (LoginCubit cubit) =>
                                            cubit.state.hiddenPassword);
                                    final String password = context.select(
                                        (LoginCubit cubit) =>
                                            cubit.state.password);
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
                                      onSubmitted: (_) => cubit.login,
                                      hiddenPassword: hiddenPassword,
                                      clickToHide: cubit.showHidePassword,
                                    );
                                  }),
                                  const SizedBox(
                                    height: 24.0,
                                  ),
                                  AppElevatedButton(
                                    text: S.of(context).login,
                                    onPressed: () => cubit.login(context),
                                  ),
                                  const SizedBox(
                                    height: 22.0,
                                  ),
                                  GestureDetector(
                                    onTap: () =>
                                        cubit.goToForgotPassword(context),
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
                            )
                          ]),
                        ),
                      ),
                    ),
                    Builder(
                      builder: (BuildContext context) {
                        final String errorMessage = context.select(
                            (LoginCubit cubit) => cubit.state.errorMessage);
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
                                  cubit.clearSuccessMessage();
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
                  final bool isLoading = context
                      .select((LoginCubit cubit) => cubit.state.isLoading);
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
