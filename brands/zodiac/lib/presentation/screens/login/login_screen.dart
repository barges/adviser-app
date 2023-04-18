import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/data/models/app_error/app_error.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/infrastructure/di/brand_manager.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.gr.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_elevated_button.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/choose_brand_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/home_screen/cubit/main_home_screen_cubit.dart';
import 'package:shared_advisor_interface/utils/utils.dart';
import 'package:zodiac/data/cache/zodiac_caching_manager.dart';
import 'package:zodiac/data/models/app_success/app_success.dart';
import 'package:zodiac/data/models/enums/validation_error_type.dart';
import 'package:zodiac/domain/repositories/zodiac_auth_repository.dart';
import 'package:zodiac/domain/repositories/zodiac_user_repository.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/infrastructure/di/inject_config.dart';
import 'package:zodiac/presentation/common_widgets/appbar/login_appbar.dart';
import 'package:zodiac/presentation/common_widgets/messages/app_error_widget.dart';
import 'package:zodiac/presentation/common_widgets/messages/app_success_widget.dart';
import 'package:zodiac/presentation/common_widgets/no_connection_widget.dart';
import 'package:zodiac/presentation/common_widgets/text_fields/app_text_field.dart';
import 'package:zodiac/presentation/common_widgets/text_fields/password_text_field.dart';
import 'package:zodiac/presentation/screens/login/login_cubit.dart';
import 'package:zodiac/presentation/screens/login/widgets/forgot_password_button_widget.dart';
import 'package:zodiac/zodiac_main_cubit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void dispose() {
    zodiacGetIt.unregister<LoginCubit>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    VoidCallback openDrawer = context.read<MainHomeScreenCubit>().openDrawer;
    return BlocProvider(
      create: (_) {
        zodiacGetIt.registerSingleton(LoginCubit(
          zodiacGetIt.get<ZodiacAuthRepository>(),
          zodiacGetIt.get<ZodiacCachingManager>(),
          zodiacGetIt.get<ZodiacMainCubit>(),
          zodiacGetIt.get<ZodiacUserRepository>(),
          zodiacGetIt.get<BrandManager>(),
          //fortunicaGetIt.get<DynamicLinkService>(),
        ));

        return zodiacGetIt.get<LoginCubit>();
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
                                  (ZodiacMainCubit cubit) =>
                                      cubit.state.appError);
                              return AppErrorWidget(
                                errorMessage: appError.getMessage(context),
                                close: () {
                                  loginCubit.clearErrorMessage();
                                },
                                onTapUrl: () =>
                                    context.push(route: const ZodiacSupport()),
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
                                            label:
                                                SZodiac.of(context).emailZodiac,
                                            hintText: SZodiac.of(context)
                                                .enterYourEmailZodiac,
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
                                            label: SZodiac.of(context)
                                                .passwordZodiac,
                                            errorType: passwordErrorType,
                                            hintText: SZodiac.of(context)
                                                .enterYourPasswordZodiac,
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
                                            title:
                                                SZodiac.of(context).loginZodiac,
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
                                            .text = 'niskov.test@gmail.com';
                                        context
                                            .read<LoginCubit>()
                                            .passwordController
                                            .text = '12345678';
                                      }
                                    },
                                    onDoubleTap: () {
                                      if (kDebugMode) {
                                        context
                                                .read<LoginCubit>()
                                                .emailController
                                                .text =
                                            'developmentree+2@gmail.com';
                                        context
                                            .read<LoginCubit>()
                                            .passwordController
                                            .text = '12345678';
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
