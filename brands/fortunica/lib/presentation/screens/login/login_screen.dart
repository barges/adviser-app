import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/data/models/app_error/app_error.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:shared_advisor_interface/infrastructure/di/brand_manager.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/choose_brand_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/home_screen/cubit/main_home_screen_cubit.dart';
import 'package:shared_advisor_interface/services/dynamic_link_service.dart';
import 'package:shared_advisor_interface/utils/utils.dart';
import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortunica/data/cache/fortunica_caching_manager.dart';
import 'package:fortunica/data/models/app_success/app_success.dart';
import 'package:fortunica/data/models/enums/validation_error_type.dart';
import 'package:fortunica/domain/repositories/fortunica_auth_repository.dart';
import 'package:fortunica/fortunica_main_cubit.dart';
import 'package:fortunica/generated/l10n.dart';
import 'package:fortunica/infrastructure/di/inject_config.dart';
import 'package:fortunica/presentation/common_widgets/appbar/login_appbar.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_elevated_button.dart';
import 'package:fortunica/presentation/common_widgets/messages/app_error_widget.dart';
import 'package:fortunica/presentation/common_widgets/messages/app_success_widget.dart';
import 'package:fortunica/presentation/common_widgets/no_connection_widget.dart';
import 'package:fortunica/presentation/common_widgets/text_fields/app_text_field.dart';
import 'package:fortunica/presentation/common_widgets/text_fields/password_text_field.dart';
import 'package:fortunica/presentation/screens/login/login_cubit.dart';
import 'package:fortunica/presentation/screens/login/widgets/forgot_password_button_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void dispose() {
    fortunicaGetIt.unregister<LoginCubit>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final VoidCallback openDrawer =
        context.read<MainHomeScreenCubit>().openDrawer;
    return BlocProvider(
      create: (_) {
        fortunicaGetIt
            .get<DynamicLinkService>()
            .checkLinkForResetPasswordFortunica(context);
        fortunicaGetIt.registerSingleton(
          LoginCubit(
            fortunicaGetIt.get<FortunicaAuthRepository>(),
            fortunicaGetIt.get<FortunicaCachingManager>(),
            fortunicaGetIt.get<FortunicaMainCubit>(),
            fortunicaGetIt.get<Dio>(),
            fortunicaGetIt.get<BrandManager>(),
          ),
        );
        return fortunicaGetIt.get<LoginCubit>();
      },
      child: Builder(builder: (context) {
        final LoginCubit loginCubit = context.read<LoginCubit>();
        final bool isOnline = context.select(
            (MainCubit cubit) => cubit.state.internetConnectionIsAvailable);
        return WillPopScope(
          onWillPop: () async {
            openDrawer();
            return false;
          },
          child: Scaffold(
            appBar: LoginAppBar(
              openDrawer: openDrawer,
            ),
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
                              final AppError appError = context.select(
                                  (FortunicaMainCubit cubit) =>
                                      cubit.state.appError);

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
                                        Builder(
                                            builder: (BuildContext context) {
                                          final ValidationErrorType
                                              emailErrorType = context.select(
                                                  (LoginCubit cubit) => cubit
                                                      .state.emailErrorType);
                                          context.select((LoginCubit cubit) =>
                                              cubit.state.emailHasFocus);
                                          return AppTextField(
                                            errorType: emailErrorType,
                                            label: SFortunica.of(context)
                                                .emailFortunica,
                                            hintText: SFortunica.of(context)
                                                .enterYourEmailFortunica,
                                            focusNode: loginCubit.emailNode,
                                            textInputType:
                                                TextInputType.emailAddress,
                                            textInputAction:
                                                TextInputAction.next,
                                            nextFocusNode:
                                                loginCubit.passwordNode,
                                            controller:
                                                loginCubit.emailController,
                                          );
                                        }),
                                        const SizedBox(
                                          height: 24.0,
                                        ),
                                        Builder(
                                            builder: (BuildContext context) {
                                          final bool hiddenPassword = context
                                              .select((LoginCubit cubit) =>
                                                  cubit.state.hiddenPassword);
                                          context.select((LoginCubit cubit) =>
                                              cubit.state.passwordHasFocus);
                                          final ValidationErrorType
                                              passwordErrorType =
                                              context.select(
                                                  (LoginCubit cubit) => cubit
                                                      .state.passwordErrorType);
                                          return PasswordTextField(
                                            controller:
                                                loginCubit.passwordController,
                                            focusNode: loginCubit.passwordNode,
                                            label: SFortunica.of(context)
                                                .passwordFortunica,
                                            errorType: passwordErrorType,
                                            hintText: SFortunica.of(context)
                                                .enterYourPasswordFortunica,
                                            textInputAction:
                                                TextInputAction.next,
                                            onSubmitted: (_) =>
                                                loginCubit.login,
                                            hiddenPassword: hiddenPassword,
                                            clickToHide:
                                                loginCubit.showHidePassword,
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
                                            title: SFortunica.of(context)
                                                .loginFortunica,
                                            onPressed: isActive
                                                ? () =>
                                                    loginCubit.login(context)
                                                : null,
                                          );
                                        }),
                                        const SizedBox(
                                          height: 22.0,
                                        ),
                                        const ForgotPasswordButtonWidget(),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onLongPress: () {
                                      if (kDebugMode) {
                                        context
                                            .read<LoginCubit>()
                                            .emailController
                                            .text = 'primrose.test1@gmail.com';
                                        context
                                            .read<LoginCubit>()
                                            .passwordController
                                            .text = '1234567891';
                                      }
                                    },
                                    onDoubleTap: () {
                                      logger.d(context
                                          .router.routeCollection.routes);
                                      if (kDebugMode) {
                                        context
                                            .read<LoginCubit>()
                                            .emailController
                                            .text = 'niskov.test@gmail.com';
                                        context
                                            .read<LoginCubit>()
                                            .passwordController
                                            .text = '00000000';
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 24.0,
                                      ),
                                      child: Utils.isDarkMode(context)
                                          ? Assets.images.logos.loginLogoDark
                                              .image(
                                              height: AppConstants.logoSize,
                                              width: AppConstants.logoSize,
                                            )
                                          : Assets.images.logos.loginLogo.image(
                                              height: AppConstants.logoSize,
                                              width: AppConstants.logoSize,
                                            ),
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
          ),
        );
      }),
    );
  }
}
