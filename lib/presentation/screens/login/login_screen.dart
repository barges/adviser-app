import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/data/cache/caching_manager.dart';
import 'package:shared_advisor_interface/data/models/app_errors/app_error.dart';
import 'package:shared_advisor_interface/data/models/app_success/app_success.dart';
import 'package:shared_advisor_interface/data/models/enums/validation_error_type.dart';
import 'package:shared_advisor_interface/domain/repositories/auth_repository.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/appbar/login_appbar.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_elevated_button.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/messages/app_error_widget.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/messages/app_success_widget.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/no_connection_widget.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/text_fields/app_text_field.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/text_fields/password_text_field.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/screens/login/login_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/login/widgets/choose_brand_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/login/widgets/forgot_password_button_widget.dart';
import 'package:shared_advisor_interface/presentation/services/dynamic_link_service.dart';
import 'package:shared_advisor_interface/presentation/utils/utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void dispose() {
    getIt.unregister<LoginCubit>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        getIt.registerSingleton(LoginCubit(
          getIt.get<AuthRepository>(),
          getIt.get<CachingManager>(),
          getIt.get<MainCubit>(),
          getIt.get<DynamicLinkService>(),
          getIt.get<Dio>(),
        ));

        return getIt.get<LoginCubit>();
      },
      child: const LoginContentWidget(),
    );
  }
}

class LoginContentWidget extends StatelessWidget {
  const LoginContentWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LoginCubit loginCubit = context.read<LoginCubit>();
    final bool isOnline = context
        .select((MainCubit cubit) => cubit.state.internetConnectionIsAvailable);
    return Scaffold(
      appBar: const LoginAppBar(),
      body: SafeArea(
        child: isOnline
            ? GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                  loginCubit.clearErrorMessage();
                  loginCubit.clearSuccessMessage();
                },
                child: Column(
                  children: [
                    Builder(
                      builder: (BuildContext context) {
                        final AppError appError = context
                            .select((MainCubit cubit) => cubit.state.appError);
                        return AppErrorWidget(
                          errorMessage: appError.getMessage(context),
                          close: () {
                            loginCubit.clearErrorMessage();
                          },
                        );
                      },
                    ),
                    Builder(
                      builder: (BuildContext context) {
                        final AppSuccess appSuccess = context.select(
                            (LoginCubit cubit) => cubit.state.appSuccess);

                        logger.d(appSuccess);

                        return AppSuccessWidget(
                          message: appSuccess.getMessage(context),
                          needEmailButton: true,
                          onClose: loginCubit.clearSuccessMessage,
                        );
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
                                    final ValidationErrorType emailErrorType =
                                        context.select((LoginCubit cubit) =>
                                            cubit.state.emailErrorType);
                                    context.select((LoginCubit cubit) =>
                                        cubit.state.emailHasFocus);
                                    return AppTextField(
                                      errorType: emailErrorType,
                                      label: S.of(context).email,
                                      hintText: S.of(context).enterYourEmail,
                                      focusNode: loginCubit.emailNode,
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
                                    context.select((LoginCubit cubit) =>
                                        cubit.state.passwordHasFocus);
                                    final ValidationErrorType
                                        passwordErrorType = context.select(
                                            (LoginCubit cubit) =>
                                                cubit.state.passwordErrorType);
                                    return PasswordTextField(
                                      controller: loginCubit.passwordController,
                                      focusNode: loginCubit.passwordNode,
                                      label: S.of(context).password,
                                      errorType: passwordErrorType,
                                      hintText: S.of(context).enterYourPassword,
                                      textInputAction: TextInputAction.next,
                                      onSubmitted: (_) => loginCubit.login,
                                      hiddenPassword: hiddenPassword,
                                      clickToHide: loginCubit.showHidePassword,
                                    );
                                  }),
                                  const SizedBox(
                                    height: 24.0,
                                  ),
                                  Builder(builder: (context) {
                                    final bool isActive = context.select(
                                      (LoginCubit cubit) =>
                                          cubit.state.buttonIsActive,
                                    );
                                    return AppElevatedButton(
                                      title: S.of(context).login,
                                      onPressed:
                                          isActive ? loginCubit.login : null,
                                    );
                                  }),
                                  const SizedBox(
                                    height: 22.0,
                                  ),
                                  const ForgotPasswordButtonWidget(),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 24.0,
                              ),
                              child: Utils.isDarkMode(context)
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
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  NoConnectionWidget(),
                ],
              ),
      ),
    );
  }
}
