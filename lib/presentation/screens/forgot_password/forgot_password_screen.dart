import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/configuration.dart';
import 'package:shared_advisor_interface/domain/repositories/auth_repository.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/no_connection_widget.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/text_fields/app_text_field.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/appbar/simple_app_bar.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_elevated_button.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/messages/app_error_widget.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/text_fields/password_text_field.dart';
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
          final bool isOnline = context.select(
              (MainCubit cubit) => cubit.state.internetConnectionIsAvailable);
          return Scaffold(
            appBar: SimpleAppBar(
              title: S.of(context).forgotPassword,
            ),
            body: SafeArea(
              child: isOnline
                  ? GestureDetector(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        cubit.clearErrorMessage();
                      },
                      child: Column(
                        children: [
                          Builder(
                            builder: (BuildContext context) {
                              final String errorMessage = context.select(
                                  (MainCubit cubit) =>
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
                          Expanded(
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.symmetric(
                                  horizontal:
                                      AppConstants.horizontalScreenPadding),
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
                                    final String emailErrorText = context
                                        .select((ForgotPasswordCubit cubit) =>
                                            cubit.state.emailErrorText);
                                    return AppTextField(
                                      errorText: emailErrorText,
                                      label: S.of(context).email,
                                      textInputType: TextInputType.emailAddress,
                                      textInputAction: TextInputAction.next,
                                      nextFocusNode: cubit.passwordNode,
                                      controller: cubit.emailController,
                                    );
                                  }),
                                  const SizedBox(
                                    height: 16.0,
                                  ),
                                  Builder(builder: (context) {
                                    final String passwordErrorText = context
                                        .select((ForgotPasswordCubit cubit) =>
                                            cubit.state.passwordErrorText);
                                    final bool hiddenPassword = context.select(
                                        (ForgotPasswordCubit cubit) =>
                                            cubit.state.hiddenPassword);
                                    return PasswordTextField(
                                      controller: cubit.passwordController,
                                      focusNode: cubit.passwordNode,
                                      label: S.of(context).password,
                                      errorText: passwordErrorText,
                                      textInputAction: TextInputAction.next,
                                      onSubmitted: (_) {
                                        FocusScope.of(context).requestFocus(
                                            cubit.confirmPasswordNode);
                                      },
                                      hiddenPassword: hiddenPassword,
                                      clickToHide: cubit.showHidePassword,
                                    );
                                  }),
                                  Builder(builder: (context) {
                                    final String confirmPasswordErrorText =
                                        context.select(
                                            (ForgotPasswordCubit cubit) => cubit
                                                .state
                                                .confirmPasswordErrorText);
                                    final bool hiddenConfirmPassword = context
                                        .select((ForgotPasswordCubit cubit) =>
                                            cubit.state.hiddenConfirmPassword);
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16.0),
                                      child: PasswordTextField(
                                        controller:
                                            cubit.confirmPasswordController,
                                        focusNode: cubit.confirmPasswordNode,
                                        label: S.of(context).confirmNewPassword,
                                        errorText: confirmPasswordErrorText,
                                        textInputAction: TextInputAction.send,
                                        onSubmitted: (_) =>
                                            cubit.resetPassword(),
                                        hiddenPassword: hiddenConfirmPassword,
                                        clickToHide:
                                            cubit.showHideConfirmPassword,
                                      ),
                                    );
                                  }),
                                  AppElevatedButton(
                                    title: S.of(context).changePassword,
                                    onPressed: cubit.resetPassword,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 24.0,
                                    ),
                                    child: Get.isDarkMode
                                        ? Assets
                                            .images.logos.forgotPasswordLogoDark
                                            .image(
                                            height: AppConstants.logoSize,
                                            width: AppConstants.logoSize,
                                          )
                                        : Assets.images.logos.forgotPasswordLogo
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
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        NoConnectionWidget(),
                      ],
                    ),
            ),
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
