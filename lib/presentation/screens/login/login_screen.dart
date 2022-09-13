import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/data/cache/cache_manager.dart';
import 'package:shared_advisor_interface/domain/repositories/auth_repository.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
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
          return Scaffold(
              appBar: const LoginAppBar(),
              body: Stack(
                children: [
                  SafeArea(
                    child: GestureDetector(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        context.read<LoginCubit>().clearErrorMessage();
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
                              horizontal: AppConstants.horizontalScreenPadding,
                            ),
                            child: Column(
                              children: [
                                Builder(builder: (BuildContext context) {
                                  final String email = context.select(
                                      (LoginCubit cubit) => cubit.state.email);
                                  return EmailFieldWidget(
                                    showErrorText: !context
                                            .read<LoginCubit>()
                                            .emailIsValid() &&
                                        email.isNotEmpty,
                                    nextFocusNode:
                                        context.read<LoginCubit>().passwordNode,
                                    controller: context
                                        .read<LoginCubit>()
                                        .emailController,
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
                                    controller: context
                                        .read<LoginCubit>()
                                        .passwordController,
                                    focusNode:
                                        context.read<LoginCubit>().passwordNode,
                                    label: S.of(context).password,
                                    errorText: S
                                        .of(context)
                                        .pleaseEnterAtLeast8Characters,
                                    textInputAction: TextInputAction.next,
                                    showErrorText: !context
                                            .read<LoginCubit>()
                                            .passwordIsValid() &&
                                        password.isNotEmpty,
                                    onSubmitted: (_) =>
                                        context.read<LoginCubit>().login,
                                    hiddenPassword: hiddenPassword,
                                    clickToHide: context
                                        .read<LoginCubit>()
                                        .showHidePassword,
                                  );
                                }),
                                const SizedBox(
                                  height: 24.0,
                                ),
                                AppElevatedButton(
                                  text: S.of(context).login,
                                  onPressed: () =>
                                      context.read<LoginCubit>().login(context),
                                ),
                                const SizedBox(
                                  height: 22.0,
                                ),
                                GestureDetector(
                                  onTap: context
                                      .read<LoginCubit>()
                                      .goToForgotPassword,
                                  child: Text(
                                    '${S.of(context).forgotPassword}?',
                                    style: Get.textTheme.titleMedium?.copyWith(
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
                                context.read<LoginCubit>().clearErrorMessage();
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
                                context
                                    .read<LoginCubit>()
                                    .clearSuccessMessage();
                              },
                            )
                          : const SizedBox.shrink();
                    },
                  )
                ],
              ));
        },
      ),
    );
  }
}
